import 'package:get/get.dart';

import '../controllers/task_info_finish_controller.dart';

class TaskInfoFinishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskInfoFinishController>(
      () => TaskInfoFinishController(),
    );
  }
}
