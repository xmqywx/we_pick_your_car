import 'package:get/get.dart';

import '../controllers/trailer_info_controller.dart';

class TrailerInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrailerInfoController>(
      () => TrailerInfoController(),
    );
  }
}
