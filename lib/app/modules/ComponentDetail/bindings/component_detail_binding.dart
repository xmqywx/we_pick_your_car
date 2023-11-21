import 'package:get/get.dart';

import '../controllers/component_detail_controller.dart';

class ComponentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComponentDetailController>(
      () => ComponentDetailController(),
    );
  }
}
