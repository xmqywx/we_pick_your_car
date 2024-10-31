import 'package:get/get.dart';

import '../controllers/dismantlers_controller.dart';

class DismantlersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DismantlersController>(
      () => DismantlersController(),
    );
  }
}
