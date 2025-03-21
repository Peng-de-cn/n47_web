import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n47_web/home/home_bloc.dart';
import '../navigation/navi_item.dart';
import '../utils/Logger.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              // 背景图
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(state.backgroundImage), // 替换为你的背景图 URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Header
              Positioned(
                top: 10,
                left: 10,
                right: 60,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.transparent, // 透明背景
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 左上角的 Home 按钮
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                          // 点击 Home 按钮的逻辑
                          Logger.d('Home clicked');
                        },
                        child: Image.asset('asset/icons/n47_logo.png', width: 60, height: 60),
                      ),
                      // 右侧导航栏
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NavItem(
                            title: 'About',
                            onTap: () {
                              Logger.d('about clicked');
                              Navigator.pushNamed(context, '/about');
                            },
                          ),
                          SizedBox(width: 20),
                          NavItem(
                            title: 'Services',
                            onTap: () {
                              Logger.d('services clicked');
                              Navigator.pushNamed(context, '/services');
                            },
                          ),
                          SizedBox(width: 20),
                          NavItem(
                            title: 'Contact',
                            onTap: () {
                              Logger.d('contact clicked');
                              Navigator.pushNamed(context, '/contact');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
