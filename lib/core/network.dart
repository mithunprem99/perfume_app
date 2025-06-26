import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:perfume_app/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  static const String baseUrl = BASEURL;
  static const String tokenKey = 'auth_token';
  static SharedPreferences? _prefs;
  static String? _token;

  static String? get token => _token;

  // Initialize SharedPreferences
  static Future<void> initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> loadToken() async {
    await initPrefs();
    _token = _prefs!.getString(tokenKey);
    if (kDebugMode) {
      print('Loaded token: $_token');
    }
  }

  // Anonymous login API
  static Future<bool> login() async {
    final url = Uri.parse('$baseUrl/anonymous-login');
    try {
      final response = await http
          .post(
            url,
            body: {
              'device_token': 'test_token',
              'device_type': '1',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['data']?['access_token'] != null) {
          _token = json['data']['access_token'];
          await initPrefs();
          await _prefs!.setString(tokenKey, _token!);
          if (kDebugMode) {
            print('Token saved: $_token');
          }
          return true;
        } else {
          if (kDebugMode) {
            print('Invalid response structure: ${response.body}');
          }
          return false;
        }
      } else {
        if (kDebugMode) {
          print('Login failed: ${response.statusCode} - ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getHomeData() async {
  if (_token == null) {
    if (kDebugMode) print('Token not set. Login required.');
    return null;
  }

  final url = Uri.parse('$baseUrl/home');
  try {
    final response = await http
        .get(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['data'] != null && data['data'] is Map<String, dynamic>) {
        final homeData = data['data'] as Map<String, dynamic>;
        if (kDebugMode) print('Home data sections: ${homeData['home_fields']?.length ?? 0}');
        return homeData;
      } else {
        if (kDebugMode) print('Invalid home data structure: ${response.body}');
        return null;
      }
    } else if (response.statusCode == 401) {
      if (kDebugMode) print('Token expired. Attempting re-login.');
      final success = await login();
      if (success) return await getHomeData();
      return null;
    } else {
      if (kDebugMode) print('Home fetch failed: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    if (kDebugMode) print('Home fetch error: $e');
    return null;
  }
}
}