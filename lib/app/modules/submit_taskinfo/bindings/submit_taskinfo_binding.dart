import 'package:get/get.dart';

import '../controllers/submit_taskinfo_controller.dart';

class SubmitTaskinfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmitTaskinfoController>(
      () => SubmitTaskinfoController(),
    );
  }
}
