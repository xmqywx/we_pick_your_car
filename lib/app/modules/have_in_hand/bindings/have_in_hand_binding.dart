import 'package:get/get.dart';

import '../controllers/have_in_hand_controller.dart';

class HaveInHandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HaveInHandController>(
      () => HaveInHandController(),
    );
  }
}
