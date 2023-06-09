import 'package:get/get.dart';
import '../../pretreatment_detail/controllers/pretreatment_detail_controller.dart';

class TaskInfoFinishController extends GetxController {
  //TODO: Implement TaskInfoFinishController
  RxBool isSubmittedSuccessfully = false.obs;
  final PretreatmentDetailController pretreatmentDetailController =
      Get.find<PretreatmentDetailController>();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    final arguments = Get.arguments;
    if (arguments != null) {
      isSubmittedSuccessfully.value = arguments['status'];
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
