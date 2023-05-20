import 'package:get/get.dart';

import '../controllers/pretreatment_detail_controller.dart';

class PretreatmentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PretreatmentDetailController>(
      () => PretreatmentDetailController(),
    );
  }
}
