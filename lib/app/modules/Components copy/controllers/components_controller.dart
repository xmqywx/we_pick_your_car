import 'package:car_wrecker/app/widget/toast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../api/wrecker.dart';
import '../templete/component_card.dart';
import 'package:scan/scan.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';

class ComponentsController extends GetxController {
  //TODO: Implement ComponentsController
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  RxList componentList = [].obs;
  RxBool canLoadMore = false.obs;
  RxMap arguments = {}.obs;
  RxString containerNumber = ''.obs;

  ScrollController listScrollController = ScrollController();
  void scrollListener() {
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        // 执行加载更多的操作
        handleToLoadMore();
      }
    });
  }

  RxList<Widget> initListView() {
    RxList<Widget> list = RxList<Widget>();
    componentList.forEach((value) {
      list.addAll([
        InkWell(
            child: ComponentCard(
                disassmblingInformation: value['disassmblingInformation'] ?? '',
                containerNumber: value['containerNumber'] ?? '',
                disassemblyNumber: value['disassemblyNumber'],
                category: value['disassemblyCategory']),
            onTap: () => Get.toNamed("/component-detail", arguments: {
                  "componentId": value['disassemblyNumber'],
                  "refresh": handleRefresh
                }))
      ]);
    });
    return list;
  }

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    arguments.value = Get.arguments;
    containerNumber.value =
        arguments.value['containerValue']['containerNumber'];
    await toRefresh();
    scrollListener();
  }

  Future getContainerInfo() async {
    var response =
        await apiGetContainerInfo(id: arguments.value['containerValue']['id']);
    print(response);
    if (response != null && response.data['message'] == 'success') {
      return response.data['data'];
    } else {
      return arguments.value['containerValue'];
    }
  }

  getComponentPageByContainerId() async {
    var response = await apiGetComponentPageByContainerId({
      "page": currentPage.value,
      "size": 10,
      "containerNumber": containerNumber.value
    });
    if (response != null && response.data['message'] == 'success') {
      totalPage.value =
          (response.data['data']['pagination']['total'] / 10).toInt() + 1;
      canLoadMore.value = currentPage.value <= totalPage.value;
      return response.data['data']['list'];
    } else {
      return [];
    }
  }

  toRefresh() async {
    var response = await getComponentPageByContainerId();
    componentList.value = response;
  }

  Future<void> handleRefresh() async {
    if (arguments.value['refresh'] != null) {
      arguments.value['refresh']();
    }
    currentPage.value = 1;
    toRefresh();
    arguments.value['containerValue'] = await getContainerInfo();
    print(arguments.value['containerValue']);
  }

  Future<void> handleToLoadMore() async {
    if (!canLoadMore.value) {
      return;
    }
    currentPage.value = currentPage.value + 1;

    var response = await getComponentPageByContainerId();
    componentList.value.addAll(response);
    componentList.refresh();
  }

  containerEdit() {
    Get.toNamed("/container-detail", arguments: {
      "isEdit": true,
      "containerValue": arguments.value['containerValue'],
      "refresh": handleRefresh
    });
  }

  containerDelete() async {
    var response = await apiDeleteContainerById({
      "ids": [arguments.value['containerValue']['id']]
    });
    if (response != null && response.data['message'] == 'success') {
      Get.back();
      if (arguments.value['refresh'] != null) {
        arguments.value['refresh']();
      }
      showCustomSnackbar(message: 'Successfully deleted.', status: '1');
    } else {
      showCustomSnackbar(
          message: 'Delete failed, please try again later.', status: '3');
    }
  }

  Future<void> alertDeleteContainerDialog() async {
    var result = await Get.dialog(
        AlertDialog(
          title: const Text("Prompt information!"),
          content:
              const Text("Are you sure you want to delete this container?"),
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
      containerDelete();
    }
  }

  // 扫码

  ScanController scanController = ScanController();
  Rx<String?> scanResult = ''.obs;

  scanQRCode() async {
    try {
      Get.to(Scaffold(
          appBar: AppBar(
            // title: const Text('Scan View'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            child: ScanView(
              controller: scanController,
              scanAreaScale: 0.7, // 自定义扫描区域的比例
              scanLineColor: Colors.green.shade400, // 自定义扫描线的颜色
              onCapture: (data) {
                // 扫描结果的回调函数
                String? dn = parseDn(data);
                Get.back();
                handleScanResult(dn);
              },
            ),
          )));
    } catch (e) {
      print('扫描二维码出错：$e');
      return null;
    }
  }

  scanPickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String? str = await Scan.parse(pickedFile.path);
      String? dn = parseDn(str);
      handleScanResult(dn);
    }
  }

  parseDn(url) {
    try {
      Uri uri = Uri.parse(url);
      return uri.queryParameters['dn'];
    } catch (e) {
      return null;
    }
  }

  handleScanResult(dn) {
    if (dn != null) {
      Get.toNamed("/component-detail", arguments: {
        "componentId": dn,
        "refresh": handleRefresh,
        "addToContainer": true,
        "containerNumber": containerNumber.value
      });
    } else {
      showCustomSnackbar(
          message: 'Scan failed, please try again.', status: '3');
    }
  }

  containerAdd() async {
    // scanQRCode();
    Get.bottomSheet(SafeArea(
        child: Container(
            color: Colors.white,
            child: Wrap(children: [
              ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () async {
                    Get.back();
                    scanQRCode();
                  }),
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Select photos'),
                  onTap: () async {
                    Get.back();
                    scanPickImage();
                  }),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () {
                  Get.back();
                },
              ),
            ]))));
  }
}
