import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfume_app/provider/perfume_provider.dart';
import 'package:perfume_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initApp();
      }
    });
  }

  Future<void> initApp() async {
    final startTime = DateTime.now();
    try {
      final perfumeProvider = Provider.of<PerfumeProvider>(
        context,
        listen: false,
      );

      await perfumeProvider.fetchProducts();

      if (perfumeProvider.error == null) {
        if (kDebugMode) {
          print(
            'Data loaded successfully. Products count: ${perfumeProvider.products.length}',
          );
        }

        final elapsed = DateTime.now().difference(startTime);
        final remaining = const Duration(seconds: 2) - elapsed;
        if (remaining > Duration.zero) {
          await Future.delayed(remaining);
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(perfumeProvider.error!)));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in initApp: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
