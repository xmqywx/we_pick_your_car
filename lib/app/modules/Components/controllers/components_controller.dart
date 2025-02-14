import 'package:car_wrecker/app/widget/toast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../api/wrecker.dart';
import '../templete/component_card.dart';
import 'package:scan/scan.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import '../../../services/storage.dart';
import '../../../services/screen_adapter.dart';
import '../../../text/paragraph.dart';

class ComponentsController extends GetxController {
  //TODO: Implement ComponentsController
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  RxList componentList = [].obs;
  RxBool canLoadMore = false.obs;
  RxBool isExist = false.obs;
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
    List<String> titles = [];
    List<Map<String, dynamic>> handleData = [];
    componentList.value.forEach((e) {
      // if (e["disassemblyCategory"] != 'Catalytic Converter') {
      int existingIndex = handleData.indexWhere((item) =>
          item['disassmblingInformation'] == e['disassmblingInformation']);
      if (existingIndex != -1) {
        handleData[existingIndex]['components'].add({
          "disassemblyNumber": e["disassemblyNumber"],
          "disassemblyDescription": e["disassemblyDescription"] ?? '----',
          "id": e["id"]
        });
      } else {
        handleData.addAll([
          {
            "disassmblingInformation": e["disassmblingInformation"],
            "components": [
              {
                "disassemblyNumber": e["disassemblyNumber"],
                "disassemblyCategory": e["disassemblyCategory"],
                "disassemblyDescription": e["disassemblyDescription"] ?? '----',
                "id": e["id"]
              }
            ]
          }
        ]);
      }
    });

    handleData.forEach((value) {
      List<Widget> components = List<Widget>.from(value['components'].map((c) {
        return InkWell(
          child: ComponentCard(
            disassmblingInformation: c['disassmblingInformation'] ?? '',
            containerNumber: c['containerNumber'] ?? '',
            disassemblyNumber: c['disassemblyNumber'] ?? '',
            disassemblyDescription: c["disassemblyDescription"] ?? '',
            // ccDes: c['ccDes'],
            // category: c['disassemblyCategory'],
          ),
          onTap: () {
            print("======================= $c");
            Get.toNamed("/component-detail", arguments: {
              "componentId": c['id'],
              "refresh": handleRefresh,
            });
          },
        );
      }));
      list.addAll([
        Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: ScreenAdapter.height(15),
                  horizontal: ScreenAdapter.width(15)),
              child: MyParagraph(
                align: TextAlign.left,
                text:
                    "${value['disassemblyCategory'] == 'Catalytic Converter' ? 'Catalytic Converter' : value['disassmblingInformation'] ?? '----'}",
                fontSize: 55,
              ),
            ),
            Column(
              children: components,
            )
          ],
        )
      ]);
    });
    return list;
  }

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    handleRefresh();
    scrollListener();
  }

  Future getContainerInfo() async {
    final userinfo = await Storage.getData('userinfo');

    var response = await apiGetWreckerContainerAndComponents(
        {"departmentId": userinfo['departmentId'], "createBy": userinfo['id']});
    if (response != null && response.data['message'] == 'success') {
      isExist.value = response.data['data']['isExist'];
      if (isExist.value) {
        containerNumber.value =
            response.data['data']['containerDetail']['containerNumber'];
        return response.data['data']['containerDetail'];
      } else {
        containerNumber.value = "Container";
        return null;
      }
    } else {
      return null;
    }
  }

  getComponentPageByContainerId() async {
    var response = await apiGetComponentPageByContainerId({
      "page": currentPage.value,
      "size": 200,
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
    // print(response);
  }

  Future<void> handleRefresh() async {
    final res = await getContainerInfo();
    if (res != null) {
      arguments.value['containerValue'] = res;
      currentPage.value = 1;
      toRefresh();
      print(arguments.value['containerValue']);
    }
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
      // if (arguments.value['refresh'] != null) {
      //   arguments.value['refresh']();
      // }
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
                String? partID = parsepartID(data);
                Get.back();
                handleScanResult(partID);
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

    // 选择图片
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // 检查选择的文件是否为图片
    if (pickedFile != null) {
      // 检查文件扩展名
      if (pickedFile.path.endsWith('.jpg') ||
          pickedFile.path.endsWith('.jpeg') ||
          pickedFile.path.endsWith('.png') ||
          pickedFile.path.endsWith('.gif') ||
          pickedFile.path.endsWith('.bmp') ||
          pickedFile.path.endsWith('.tiff') ||
          pickedFile.path.endsWith('.webp')) {
        String? str = await Scan.parse(pickedFile.path);
        String? partID = parsepartID(str);
        handleScanResult(partID);
      } else {
        // 如果选择的文件不是图片，显示提示
        showCustomSnackbar(
          message: 'Please select only image files.',
          status: '3',
        );
      }
    }
  }

  parsepartID(url) {
    try {
      Uri uri = Uri.parse(url);
      return uri.queryParameters['partID'];
    } catch (e) {
      return null;
    }
  }

  handleScanResult(partID) {
    if (partID != null) {
      Get.toNamed("/component-detail", arguments: {
        "componentId": partID,
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
