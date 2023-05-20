import 'package:get/get.dart';

import '../controllers/personal_center_controller.dart';

class PersonalCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalCenterController>(
      () => PersonalCenterController(),
    );
  }
}
