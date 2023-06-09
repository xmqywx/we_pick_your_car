import 'package:get/get.dart';

import '../controllers/tabs_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../task_list/controllers/task_list_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../scheduling/controllers/scheduling_controller.dart';
import '../../pretreatment/controllers/pretreatment_controller.dart';

//配置binding 懒加载控制器
class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(
      () => TabsController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<TaskListController>(
      () => TaskListController(),
    );
    Get.lazyPut<UserController>(
      () => UserController(),
    );
    Get.lazyPut<SchedulingController>(
      () => SchedulingController(),
    );
    Get.lazyPut<PretreatmentController>(() => PretreatmentController());
  }
}
