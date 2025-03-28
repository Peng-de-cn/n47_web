import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/generated/app_localizations.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@n47.eu',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      final errorMessage = '${AppLocalizations.of(context)!.urlError}: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1200,
              minHeight: 200,
            ),
            child: buildResponsiveLayout(context, constraints.maxWidth),
          );
        },
      ),
    );
  }

  Widget buildResponsiveLayout(BuildContext context, double screenWidth) {
    if (screenWidth > 900) {
      return buildWideDesktopLayout(context);
    } else {
      return buildNarrowMobileLayout(context);
    }
  }

  Widget buildWideDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Horizontally center
      crossAxisAlignment: CrossAxisAlignment.start, // Vertically from the top
      children: [
        Expanded( // force equal division of space
          child: buildContactLayout(context),
        ),
        Expanded(
          child: buildSocialMediaLayout(context),
        ),
      ],
    );
  }

  Widget buildNarrowMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildContactLayout(context),
        const SizedBox(height: 60),
        buildSocialMediaLayout(context),
      ],
    );
  }

  Widget buildContactLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Vertically center
      children: [
        Text(
          AppLocalizations.of(context)!.contactTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _launchEmail,
            child: const Text(
              'info@n47.eu',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => {
                  showPrivacyPolicyDialog(context)
                },
                child: Text(
                  AppLocalizations.of(context)!.privacyPolicy,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => {
                  showImprintDialog(context)
                },
                child: Text(
                  AppLocalizations.of(context)!.imprint,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSocialMediaLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.followTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 15,
          children: buildSocialIcons(context),
        ),
        const SizedBox(height: 40),
        Text(
          AppLocalizations.of(context)!.copyright,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  List<Widget> buildSocialIcons(BuildContext context) {
    return [
      buildSocialIcon(context, 'assets/icons/icon_instagram.png', 'https://www.instagram.com/n47.eu/'),
      buildSocialIcon(context, 'assets/icons/icon_youtube.png', 'https://www.youtube.com/channel/UCVSaaojGTCzfQCWY2z-_CFQ/featured'),
      buildSocialIcon(context, 'assets/icons/icon_rednote.png', null, onTap: () {
        showRedNoteDialog(context);
      }),
      buildSocialIcon(context, 'assets/icons/icon_wechat.png', null, onTap: () {
        showWeChatDialog(context);
      }),

    ];
  }

  Widget buildSocialIcon(
      BuildContext context,
      String assetPath,
      String? url, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap ?? (url != null ? () => _launchUrl(context, url) : null),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Image.asset(
          assetPath,
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget buildLink(BuildContext context, String text, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(context, url),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.privacyPolicyTitle),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Text(AppLocalizations.of(context)!.privacyPolicyDetail),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }

  void showImprintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.imprintTitle),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Text(AppLocalizations.of(context)!.imprintDetail),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }

  void showWeChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.wechatDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Image.asset(
                  'assets/qr/wechat_qr.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.wechatDialogText),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }

  void showRedNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.redNoteDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Image.asset(
                  'assets/qr/rednote_qr.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.redNoteDialogText),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }
}
