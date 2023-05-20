import 'package:get/get.dart';

import '../controllers/pretreatment_controller.dart';

class PretreatmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PretreatmentController>(
      () => PretreatmentController(),
    );
  }
}
