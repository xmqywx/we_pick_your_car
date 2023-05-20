import 'package:get/get.dart';

import '../controllers/user_controller.dart';

//配置binding 懒加载控制器
class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );
  }
}
