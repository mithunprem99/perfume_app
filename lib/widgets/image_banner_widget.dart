import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageBannerWidget extends StatelessWidget {
  final String? imageUrl;

  const ImageBannerWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Delivery',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/logo.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}