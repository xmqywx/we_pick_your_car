import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../tabs/controllers/tabs_controller.dart';
import '../../pretreatment/controllers/pretreatment_controller.dart';
import '../../../services/https_client.dart';
import '../../../services/handle_status.dart';
import '../../../controllers/is_loading_controller.dart';
import '../../../api/order.dart';
import '../../../widget/toast.dart';
import '../../../services/screen_adapter.dart';
import '../../generate_signature/views/generate_signature_view.dart';
import 'dart:convert';

class PretreatmentDetailController extends GetxController {
  final IsLoadingController isLoadingController =
      Get.find<IsLoadingController>();
  // final PretreatmentController pretreatmentController =
  //     Get.find<PretreatmentController>();
  //TODO: Implement PretreatmentDetailController
  final TabsController myController = Get.find<TabsController>();
  HttpsClient httpsClient = HttpsClient();
  RxMap mapData = {}.obs;
  RxMap orderDetail = {}.obs;
  RxMap arguments = {}.obs;
  RxString currentStatus = "".obs;
  RxBool toFinishTask = false.obs;

  // ---------------表单
  // RxString modelNumber = "".obs;
  // modelNumberChange(value) {
  //   modelNumber.value = value;
  //   update();
  // }

  // RxString carColor = "".obs;
  // carColorChange(value) {
  //   carColor.value = value;
  //   update();
  // }

  // RxString paymentMethod = "".obs;
  // paymentMethodChange(value) {
  //   paymentMethod.value = value;
  //   update();
  // }

  //----------------上传图片
  // RxList imageFileDir = [].obs;
  // changeImageFileDir(List XFiles) {
  //   print(XFiles);
  //   imageFileDir.value = XFiles;
  // }

  //----------------键盘
  RxBool fingerboardFlag = false.obs;
  FocusNode focusNode = FocusNode();

  Future<void> alertStartDialog() async {
    var result = await Get.dialog(
        AlertDialog(
          title: const Text("Prompt information!"),
          content: const Text("Are you sure you want to start this task now?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back(result: 'Cancel');
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Get.back(result: 'Ok');
              },
            )
          ],
        ),
        barrierDismissible: false);
    if (result == 'Ok') {
      await startCurrentTask();
      await initDetail();
    }
  }

  Future<void> alertSendInvoiceDialog() async {
    var result = await Get.dialog(
        AlertDialog(
          title: const Text("Prompt information!"),
          content: const Text("Are you sure you want to send invoice?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back(result: 'Cancel');
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Get.back(result: 'Ok');
              },
            )
          ],
        ),
        barrierDismissible: false);
    if (result == 'Ok') {
      // await startCurrentTask();
      await getCustomerInfo();
      var sendRes = await apiSendInvoice(
          name: orderDetail['firstName'],
          id: arguments['id'],
          price: orderDetail['actualPaymentPrice'],
          email: orderDetail['emailAddress']);
      if (sendRes == null) {
        showCustomSnackbar(
            message: 'Send failed, please try again later.', status: '3');
        return;
      }
      if (sendRes.data['message'] == 'success') {
        showCustomSnackbar(message: 'Send successful.');
      } else {
        showCustomSnackbar(
            message: 'Send failed,' + sendRes.data['message'], status: '3');
      }
      // await initDetail();
    }
  }

  Future<void> alertEndDialog() async {
    var result = await Get.dialog(
        AlertDialog(
          title: const Text("Prompt information!"),
          content: const Text("Are you sure you want to end this job now?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back(result: 'Cancel');
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Get.back(result: 'Ok');
              },
            )
          ],
        ),
        barrierDismissible: false);
    if (result == 'Ok') {
      // await endCurrentTask();
      // await initDetail();
      // toFinishTask.value = true;
      // update();
      // Get.toNamed('/submit-taskinfo');
      var res = await endCurrentTask(data: {}, isFinish: true);
      if (res) {
        initDetail();
        showCustomSnackbar(message: "The current job has ended.");
        myController.getJobListPageData();
        await myController.initializationList();
        await myController.initializationJobViewList();
      }
    }
  }

  //开始当前任务
  startCurrentTask() async {
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    var response = await httpsClient.post('/admin/job/info/update',
        data: {"id": arguments['id'], "schedulerStart": "$timestamp"});
    if (response != null && response.data['message'] == 'success') {
      arguments['status'] = 'In progress';
      update();
    } else {
      print('Token expired or network error');
    }
  }

  //结束当前任务
  endCurrentTask({required Map data, bool isFinish = false}) async {
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    Map submitData = {
      "id": arguments['id'],
      // /*  "schedulerEnd": "$timestamp", */ "status": 4
    };
    if (isFinish) {
      submitData["status"] = 4;
    }
    // if (data.isNotEmpty) {
    //   submitData.addAll(data);
    // }
    data['id'] = arguments['orderID'];
    print(data);
    var response =
        await httpsClient.post('/admin/order/info/update', data: data);
    print(response);
    if (response != null && response.data['message'] == 'success') {
      var jobResponse =
          await httpsClient.post('/admin/job/info/update', data: submitData);
      print("update order successfully.");
      if (jobResponse != null && response.data['message'] == 'success') {
        print("update job successfully.");
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //获取订单详情
  getCustomerInfo() async {
    var response = await apiGetIdOrder(arguments['orderID']);
    if (response != null && response.data['message'] == 'success') {
      orderDetail.value = response.data['data']['list']![0] ?? {};
      print("orderDetail finish");
    } else {
      print('Token expired or network error');
    }
  }

  findOrderDetail() {
    var findData = myController.orderList.firstWhereOrNull((v) {
      return v['id'] == arguments['orderID'];
    });
    if (findData != null) {
      // 处理找到的元素
      orderDetail = findData;
      update();
    } else {
      // 处理找不到元素的情况
    }
  }

  resetJobDetail() async {
    var response = await httpsClient
        .post('/admin/job/info/list', data: {"id": arguments['id']});
    if (response != null && response.data['message'] == 'success') {
      arguments.value = response.data['data']![0] ?? {};
      // currentStatus.value = handleStatus(arguments['schedulerStart'],
      //     arguments['schedulerEnd'], arguments['expectedDate']);
      currentStatus.value = handleStatus(arguments['status']);
      update();
      print("arguments reseted");
    } else {
      print('Token expired or network error');
    }
  }

  //确认行为后重新渲染
  initDetail() async {
    await resetJobDetail();
    await getCustomerInfo();
    initFields();
    update();
  }

  //Edit 字段内容
  RxBool isEdit = false.obs;
  void editIsEdit() {
    // updateJobInfo();
    isEdit.value = !isEdit.value;
  }

  void handleToEdit() {
    editIsEdit();
  }

/**
      "modelNumber": modelNumber.value,
      "carColor": carColor.value,
      "imageFileDir": json.encode(imageFileDir.value),
      "signature": signature.value,
      "actualPaymentPrice": actualPayPrice.value,
      "payMethod": paymentMethod.value
 */
  void initFields() {
    modelNumber.value = orderDetail['modelNumber'] ?? "";
    carColor.value = orderDetail['carColor'] ?? "";
    actualPayPrice.value = orderDetail['actualPaymentPrice'] ?? "";
    paymentMethod.value = orderDetail['payMethod'] ?? "";
    if (orderDetail['imageFileDir'] != null) {
      var cloneData = json
          .decode(orderDetail['imageFileDir'])
          .map((e) => e.toString())
          .toList();
      // print(cloneData);
      // print(cloneData[0].runtimeType);
      if (cloneData != null) {
        List<String> stringList = cloneData.cast<String>().toList();
        imageFileDir.value = stringList;
      }
      print(cloneData);
      // imageFileDir.value = orderDetail['imageFileDir'].replaceAll('"', "");
    } else {
      imageFileDir.value = <String>[];
    }
    imageFileDir.refresh();
    if (orderDetail['signature'] != null) {
      signature.value = orderDetail['signature'];
      print(orderDetail['signature']);
    } else {
      signature.value = "";
    }
    signature.refresh();
  }

  void handleToCancel() {
    initFields();
    editIsEdit();
  }

  void handleToConfirm() async {
    var flag = await updateJobInfo();
    if (flag) {
      isEdit.value = false;
      initDetail();
    }
  }
  // void initDetail() {

  // }
  @override
  void onInit() async {
    super.onInit();
    arguments.value = Get.arguments;
    // currentStatus.value = handleStatus(arguments['schedulerStart'],
    //     arguments['schedulerEnd'], arguments['expectedDate']);
    currentStatus.value = handleStatus(arguments['status']);
    await getCustomerInfo();
    // if (orderDetail['imageFileDir'] != null) {
    //   var cloneData = json.decode(orderDetail['imageFileDir']);
    //   if (cloneData != null) {
    //     imageFileDir.value = cloneData.cast<String>().toList();
    //   }
    //   print(cloneData);
    //   // imageFileDir.value = orderDetail['imageFileDir'].replaceAll('"', "");
    // }
    // if (orderDetail['signature'] != null) {
    //   signature.value = orderDetail['signature'];
    //   print(orderDetail['signature']);
    // }
    initFields();
    update();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // 键盘打开时的操作

        fingerboardFlag.value = true;
      } else {
        // 键盘关闭时的操作

        fingerboardFlag.value = false;
      }
    });
    // "imageFileDir": imageFileDir.value.toString(),
    //   "signature": signature.value,
  }

// -*-*-*-*-*-*-*-*-*- edit
  RxString modelNumber = "".obs;
  modelNumberChange(value) {
    modelNumber.value = value;
    print(value);
  }

  RxString carColor = "".obs;
  carColorChange(value) {
    carColor.value = value;
  }

  RxString paymentMethod = "Cheque".obs;
  paymentMethodChange(value) {
    paymentMethod.value = value;
    print(paymentMethod.value);
    // paymentMethod.refresh();
  }

  RxString actualPayPrice = "".obs;
  actualPayPriceChange(value) {
    actualPayPrice.value = value;
  }

  //----------------上传图片
  RxList<String> imageFileDir = <String>[].obs;
  changeImageFileDir(List<String> XFiles) {
    print(XFiles);
    imageFileDir.value = XFiles;
    imageFileDir.refresh();
  }

  RxString signature = "".obs;
  changeSignature(String data) {
    signature.value = data;
    signature.refresh();
  }

  //----------------更新
  updateJobInfo() async {
    // List fields = [
    //   {
    //     "value": modelNumber.value,
    //     "message": "Please add the vehicle model number."
    //   },
    //   {
    //     "value": carColor.value,
    //     "message": "Please add the color of this vehicle."
    //   },
    //   {
    //     "value": paymentMethod.value,
    //     "message": "Please add the payment method."
    //   },
    //   {
    //     "value": actualPayPrice.value,
    //     "message": "Please add the actual price."
    //   },
    //   {"value": imageFileDir.value, "message": "Please add the site photos."},
    //   {
    //     "value": signature.value,
    //     "message": "Please upload customer signature."
    //   },
    // ];

    // // 使用 forEach 循环判断每一项是否存在空值
    // bool hasEmptyValue = false;
    // fields.forEach((item) {
    //   if (item['value'].isEmpty) {
    //     if (hasEmptyValue == false) {
    //       hasEmptyValue = true;
    //       showCustomSnackbar(message: item['message'], status: '3');
    //     }
    //   }
    // });

    // // 如果存在空值，则直接返回，不执行下面的代码
    // if (hasEmptyValue) {
    //   return;
    // }

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
    var res = await endCurrentTask(data: {
      "modelNumber": modelNumber.value,
      "carColor": carColor.value,
      "imageFileDir": json.encode(imageFileDir.value),
      "signature": signature.value,
      "actualPaymentPrice": actualPayPrice.value,
      "payMethod": paymentMethod.value
    }, isFinish: false);

    if (res) {
      // Get.offAllNamed("/task-info-finish", arguments: {"status": true});
      // showCustomSnackbar(message: 'Update succefuss.');
      showCustomSnackbar(message: 'update successfully.');
    } else {
      showCustomSnackbar(message: 'Update failed, please try again later.');
    }
    return res;
  }

  // 签名 bottom sheet
  openBottomSheet() {
    if (isEdit.value) {
      Get.bottomSheet(
        Container(
          height: ScreenAdapter.height(2000),
          // color: Colors.red,
          child: DemoPage(),
        ),
        enableDrag: false,
        isScrollControlled: true,
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
