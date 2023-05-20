import 'package:get/get.dart';

import '../controllers/pass_login_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../tabs/controllers/tabs_controller.dart';

class PassLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassLoginController>(
      () => PassLoginController(),
    );
    Get.lazyPut<TabsController>(() => TabsController());
  }
}
