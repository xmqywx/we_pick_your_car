import 'package:get/get.dart';

import '../controllers/unaccomplished_controller.dart';

class UnaccomplishedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnaccomplishedController>(
      () => UnaccomplishedController(),
    );
  }
}
