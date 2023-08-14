import 'package:get/get.dart';

import '../controllers/no_role_controller.dart';

class NoRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoRoleController>(
      () => NoRoleController(),
    );
  }
}
