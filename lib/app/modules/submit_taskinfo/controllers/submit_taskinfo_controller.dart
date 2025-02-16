import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:get/get.dart';
import '../../pretreatment_detail/controllers/pretreatment_detail_controller.dart';
import 'package:flutter/material.dart';
import '../../generate_signature/views/generate_signature_view.dart';
import '../../../widget/toast.dart';

class SubmitTaskinfoController extends GetxController {
  //TODO: Implement SubmitTaskinfoController
  final PretreatmentDetailController pretreatmentDetailController =
      Get.find<PretreatmentDetailController>();
  // ---------------表单

  RxString modelNumber = "".obs;
  modelNumberChange(value) {
    modelNumber.value = value;
  }

  RxString carColor = "".obs;
  carColorChange(value) {
    carColor.value = value;
  }

  RxString paymentMethod = "Cheque".obs;
  paymentMethodChange(value) {
    paymentMethod.value = value;
  }

  RxString actualPayPrice = "".obs;
  actualPayPriceChange(value) {
    actualPayPrice.value = value;
  }

  //----------------上传图片
  RxList imageFileDir = [].obs;
  changeImageFileDir(List XFiles) {
    print(XFiles);
    imageFileDir.value = XFiles;
  }

  RxString signature = "".obs;
  changeSignature(String data) {
    signature.value = data;
  }

  //----------------更新
  updateJobInfo() async {
    List fields = [
      {
        "value": modelNumber.value,
        "message": "Please add the vehicle model number."
      },
      {
        "value": carColor.value,
        "message": "Please add the color of this vehicle."
      },
      {
        "value": paymentMethod.value,
        "message": "Please add the payment method."
      },
      {
        "value": actualPayPrice.value,
        "message": "Please add the actual price."
      },
      // {"value": imageFileDir.value, "message": "Please add the site photos."},
      {
        "value": signature.value,
        "message": "Please upload customer signature."
      },
    ];

    // 使用 forEach 循环判断每一项是否存在空值
    bool hasEmptyValue = false;
    for (var item in fields) {
      if (item['value'].isEmpty) {
        if (hasEmptyValue == false) {
          hasEmptyValue = true;
          showCustomSnackbar(message: item['message'], status: '3');
        }
      }
    }

    // 如果存在空值，则直接返回，不执行下面的代码
    if (hasEmptyValue) {
      return;
    }

    // if (modelNumber.value.isEmpty) {
    //   Get.snackbar(
    //       "Error", "Please add the vehicle model number. ${modelNumber.value}");
    //   return;
    // } else if (carColor.value.isEmpty) {
    //   Get.snackbar("Error", "Please add the color of this vehicle.");
    //   return;
    // } else if (imageFileDir.value.isEmpty) {
    //   Get.snackbar("Error", "Please add the Please add the site photos.");
    //   return;
    // } else if (signature.value.isEmpty) {
    //   Get.snackbar("Error", "Please upload customer signature.");
    //   return;
    // } else if (actualPayPrice.value.isEmpty) {
    //   Get.snackbar("Error", "Please add the actual payment price.");
    //   return;
    // } else if (paymentMethod.value.isEmpty) {
    //   Get.snackbar("Error", "Please add the paymentMethod.");
    //   return;
    // }
    if (num.tryParse(actualPayPrice.value) == null) {
      showCustomSnackbar(
          message: 'Please enter the correct price.', status: '3');
      return;
    }
    var res = await pretreatmentDetailController.endCurrentTask(data: {
      "modelNumber": modelNumber.value,
      "carColor": carColor.value,
      // "imageFileDir": json.encode(imageFileDir.value),
      "signature": signature.value,
      "actualPaymentPrice": actualPayPrice.value,
      "payMethod": paymentMethod.value
    });

    if (res) {
      Get.offAllNamed("/task-info-finish", arguments: {"status": true});
    } else {
      Get.toNamed("/task-info-finish", arguments: {"status": false});
    }
  }

  // 签名 bottom sheet
  openBottomSheet() {
    Get.bottomSheet(
      SizedBox(
        height: ScreenAdapter.height(2000),
        // color: Colors.red,
        child: const DemoPage(),
      ),
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  final count = 0.obs;



  void increment() => count.value++;
}
