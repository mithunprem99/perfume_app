import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final Map<String, dynamic> banner;

  const BannerWidget({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: banner['image'] ?? '',
                  height: 200,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}