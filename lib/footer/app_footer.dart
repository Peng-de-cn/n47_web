import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
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
              minHeight: 200, // 添加最小高度约束
            ),
            child: constraints.maxWidth > 600
                ? buildWideLayout()
                : buildNarrowLayout(),
          );
        },
      ),
    );
  }

  Widget buildWideLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 仅横向居中
      crossAxisAlignment: CrossAxisAlignment.start, // 垂直方向从顶部开始
      children: [
        // 左侧内容 (联系方式)
        Container(
          width: 500, // 固定宽度或使用约束
          padding: const EdgeInsets.only(right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
            children: [
              const Text(
                'Contact us',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'N47 GmbH\nMusterstraße 47\n10115 Berlin\nDeutschland',
                textAlign: TextAlign.center, // 文本居中
                style: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
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
            ],
          ),
        ),

        // 右侧内容 (链接和版权)
        Container(
          width: 500, // 与左侧相同宽度
          padding: const EdgeInsets.only(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
            children: [
              const Text(
                'Links',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 链接居中
                children: [
                  GestureDetector(
                    onTap: () => _launchUrl('https://www.n47.eu/datenschutz'),
                    child: const Text(
                      'Datenschutz',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => _launchUrl('https://www.n47.eu/impressum'),
                    child: const Text(
                      'Impressum',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Copyright © All Rights Reserved',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 窄屏布局 - 垂直堆叠
  Widget buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 联系方式
        const Text(
          'Contact us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'N47 GmbH\nMusterstraße 47\n10115 Berlin\nDeutschland',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
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

        const SizedBox(height: 40),

        // 链接
        const Text(
          'Links',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            GestureDetector(
              onTap: () => _launchUrl('https://www.n47.eu/datenschutz'),
              child: const Text(
                'Datenschutz',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => _launchUrl('https://www.n47.eu/impressum'),
              child: const Text(
                'Impressum',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        // 版权信息
        const Text(
          'Copyright © All Rights Reserved',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
