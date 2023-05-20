import 'package:get/get.dart';

import '../controllers/generate_signature_controller.dart';

class GenerateSignatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateSignatureController>(
      () => GenerateSignatureController(),
    );
  }
}
