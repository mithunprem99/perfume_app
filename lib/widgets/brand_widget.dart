import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BrandsWidget extends StatelessWidget {
  final List<dynamic> brands;

  const BrandsWidget({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shop By Brands',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text("View all", style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: brand['image'] ?? '',
                        width: 170,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 7),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
