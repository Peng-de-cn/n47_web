import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cookie_consent_dialog.dart';

class CookieConsentOverlay extends StatefulWidget {
  const CookieConsentOverlay({super.key});

  @override
  State<CookieConsentOverlay> createState() => _CookieConsentOverlayState();
}

class _CookieConsentOverlayState extends State<CookieConsentOverlay> {
  bool _shouldShowDialog = false;

  @override
  void initState() {
    super.initState();
    _checkConsentStatus();
  }

  Future<void> _checkConsentStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasChosen = prefs.containsKey('cookies_accepted');
    if (!hasChosen) {
      setState(() => _shouldShowDialog = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showConsentDialog();
      });
    }
  }

  void _showConsentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CookieConsentDialog(
        onAccept: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('cookies_accepted', true);
        },
        onReject: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('cookies_accepted', false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // 这个组件不显示任何 UI
  }
}
