import 'package:bujuan/pages/home/home_controller.dart';
import 'package:bujuan/pages/index/index_controller.dart';
import 'package:bujuan/pages/user/user_controller.dart';
import 'package:get/get.dart';

import '../play_list/playlist_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    // Get.lazyPut(() => UserController());
    Get.lazyPut(() => Home());
    // Get.lazyPut<IndexController>(() => IndexController());
    // Get.lazyPut(() => PlayListController());
    // Get.lazyPut(() => LoginController());
  }
}