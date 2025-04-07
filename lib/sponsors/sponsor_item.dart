
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/Logger.dart';

class SponsorItem extends StatelessWidget {
  final String imagePath;
  final String url;
  final double maxSize;

  const SponsorItem({
    required this.imagePath,
    required this.url,
    required this.maxSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = maxSize * 0.6;

    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _launchSponsorUrl,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchSponsorUrl() async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Logger.e('Could not launch $url: $e');
    }
  }
}