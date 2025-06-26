import 'package:flutter/foundation.dart';
import 'package:perfume_app/core/network.dart';
import 'package:perfume_app/models/perfumes.dart';

class PerfumeProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _homeData;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get homeData => _homeData;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        await NetworkService.loadToken();
        if (NetworkService.token == null) {
          if (kDebugMode) print('Attempt $attempt: Logging in...');
          final success = await NetworkService.login();
          if (!success) {
            if (attempt == 2) {
              _isLoading = false;
              _error = 'Login failed after $attempt attempts. Check network.';
              notifyListeners();
            }
            await Future.delayed(Duration(seconds: 2));
            continue;
          }
        }

        final homeDataJson = await NetworkService.getHomeData();
        _homeData = homeDataJson;

        if (homeDataJson != null && homeDataJson['home_fields'] != null) {
          try {
            final List<dynamic>? rawHomeFields = homeDataJson['home_fields'];
            List<Product> allProducts = [];
            if (rawHomeFields != null) {
              for (var item in rawHomeFields) {
                if (item is Map<String, dynamic>) {
                  final homeField = HomeField.fromJson(item);
                  if (homeField.products != null)
                    allProducts.addAll(homeField.products!);
                }
              }
            }
            _products = allProducts;
            if (kDebugMode) print('Total products loaded: ${_products.length}');
            break;
          } catch (e) {
            if (kDebugMode) print('Error parsing home fields: $e');
            _error = 'Failed to parse home data.';
          }
        } else {
          _error = 'Failed to load home data.';
        }
      } catch (e) {
        if (kDebugMode) print('Error in fetchProducts (Attempt $attempt): $e');
        _error = 'An error occurred while loading data (Attempt $attempt).';
      }

      if (attempt == 2 && _error != null) {
        _isLoading = false;
        notifyListeners();
      }
      await Future.delayed(
        Duration(seconds: 2 << attempt),
      ); 
    }

    _isLoading = false;
    notifyListeners();
  }
}
