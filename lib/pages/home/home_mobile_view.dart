import 'package:bujuan/pages/home/home_controller.dart';
import 'package:bujuan/pages/index/main_view.dart';
import 'package:bujuan/routes/app_pages.dart';
import 'package:bujuan/widget/simple_extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/constants/colors.dart';
import '../index/album_view.dart';
import '../index/index_view.dart';
import '../user/user_view.dart';

class HomeMobileView extends GetView<HomeController> {
  const HomeMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leadingWidth: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 68.w,
                height: 68.w,
              ),
              const Expanded(child: Text('  Tireless')),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(Routes.setting),
                icon: const Icon( IconData(0xe69e, fontFamily: 'iconfont')),)
          ],
        ),
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            MainView(),
            AlbumView(),
            IndexView(),
            UserView(),
          ],
        ),
      ),
      title: "Application",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      // 开启FPS监控
      themeMode: ThemeMode.system,
      getPages: AppPages.routes,
      defaultTransition: Transition.circularReveal,
      // transitionDuration: const Duration(milliseconds: 200),
      routingCallback: (Routing? r) {
        HomeController.to.changeRoute(r?.current);
      },
    );
  }
}
