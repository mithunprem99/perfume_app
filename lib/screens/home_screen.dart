import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perfume_app/provider/perfume_provider.dart';
import 'package:perfume_app/widgets/brand_widget.dart';
import 'package:perfume_app/widgets/category_widget.dart';
import 'package:provider/provider.dart';
import 'package:perfume_app/widgets/carousel_widget.dart';
import 'package:perfume_app/widgets/collection_widget.dart';
import 'package:perfume_app/widgets/banner_widget.dart';
import 'package:perfume_app/widgets/banner_grid_widget.dart';
import 'package:perfume_app/widgets/image_banner_widget.dart';
import 'package:perfume_app/widgets/image_banner_delivery_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PerfumeProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerfumeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (provider.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchProducts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final rawHomeFields = provider.homeData?['home_fields'] ?? [];
        final homeFields = rawHomeFields
            .where((e) => e is Map)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        if (kDebugMode) {
          print('Total sections: ${homeFields.length}');
          for (var field in homeFields) {
            print('Section type: ${field['type']}');
          }
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Text('Welcome, '),
                Text('User!', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined),
                onPressed: () {},
                color: Colors.black,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                      
                      },
                      icon: const Icon(Icons.qr_code_scanner, size: 20),
                      label: const Text("Scan Here"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchProducts(),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                if (homeFields.isEmpty)
                  const Center(child: Text("No content available"))
                else
                  ...homeFields.map((field) {
                    final type = field['type']?.toString();
                    switch (type) {
                      case 'carousel':
                        return CarouselWidget(
                          items: field['carousel_items'] ?? [],
                        );
                      case 'brands':
                        return BrandsWidget(brands: field['brands'] ?? []);
                      case 'category':
                        return CategoriesWidget(
                          categories: field['categories'] ?? [],
                        );
                      case 'collection':
                        final products = field['products'] ?? [];
                        final collectionName = field['name']?.toString() ?? '';
                        if (products is List && products.isNotEmpty) {
                          return CollectionWidget(
                            products: products,
                            collectionName: collectionName,
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('No products found in collection'),
                          );
                        }
                      case 'banner':
                        return BannerWidget(banner: field['banner'] ?? {});
                      case 'banner-grid':
                        return BannerGridWidget(
                          banners: field['banners'] ?? [],
                        );
                      case 'rfq':
                        return ImageBannerDeliveryWidget(
                          imageUrl: field['image'],
                        );
                      case 'future-order':
                        return ImageBannerWidget(imageUrl: field['image']);
                      default:
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Unsupported section: $type',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                    }
                  }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
