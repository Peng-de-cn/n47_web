
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/logger_util.dart';
import 'dart:html' as html;

class SupporterItem extends StatelessWidget {
  final String imagePath;
  final String url;
  final double maxSize;

  const SupporterItem({
    required this.imagePath,
    required this.url,
    required this.maxSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = maxSize * 0.6;
    final hasUrl = url.trim().isNotEmpty;

    return Center(
      child: MouseRegion(
        cursor: hasUrl ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: hasUrl
              ? () {
                  _launchSponsorUrl();
                }
              : null,
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
      if (kIsWeb) {
        // Web 环境
        final userAgent = html.window.navigator.userAgent.toLowerCase();
        final isIosSafari = userAgent.contains('iphone') ||
            userAgent.contains('ipad') ||
            (userAgent.contains('safari') && !userAgent.contains('chrome'));

        if (isIosSafari) {
          html.window.location.href = url;
        } else {
          await _launchWithUrlLauncher();
        }
      } else {
        await _launchWithUrlLauncher();
      }
    } catch (e) {
      logger.e('Could not launch $url: $e');
    }
  }

  Future<void> _launchWithUrlLauncher() async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}