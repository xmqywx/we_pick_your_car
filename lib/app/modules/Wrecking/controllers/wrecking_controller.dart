import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:flutter/material.dart';
import '../../../services/https_client.dart';
import 'dart:convert';

class WreckingController extends GetxController {
  HttpsClient httpsClient = HttpsClient();
  RxString barcodeTxt = "".obs;
  RxMap wreckedData = {}.obs;
  RxBool isMore = false.obs;
  final Rx<TextEditingController> textEditingController =
      TextEditingController().obs;
  Future<void> scanBarcode() async {
    // final barcode = await FlutterBarcodeScanner.scanBarcode(
    //   '#ff6666', // 扫描框的颜色
    //   '取消', // 取消按钮的文本
    //   true, // 是否显示闪光灯按钮
    //   ScanMode.BARCODE, // 扫描模式，这里选择条形码
    // );

    // barcodeTxt.value = barcode;
    var res = await Get.to(const SimpleBarcodeScannerPage());
    if (res is String) {
      barcodeTxt.value = res;
      onSearch();
    }
  }

  onSearchChange(value) {
    barcodeTxt.value = value;
  }

  onSearch() async {
    isMore.value = false;
    Map searchData = {"disassemblyNumber": barcodeTxt.value};
    print(searchData);
    var response =
        await httpsClient.post('/admin/car/carWrecked/list', data: searchData);
    if (response != null && response.data['message'] == 'success') {
      print(response.data['data']);
      Map cloneData = response.data['data'][0];
      print(cloneData);
      if (cloneData['disassemblyImages'] != null) {
        var cloneData1 = json
            .decode(cloneData['disassemblyImages'])
            .map((e) => e.toString())
            .toList();
        // print(cloneData);
        // print(cloneData[0].runtimeType);
        if (cloneData1 != null) {
          List<String> stringList = cloneData1.cast<String>().toList();
          imageFileDir.value = stringList;
        }
        print(cloneData);
        // imageFileDir.value = orderDetail['imageFileDir'].replaceAll('"', "");
      } else {
        imageFileDir.value = <String>[];
      }
      if (cloneData['disassemblyCategory'] == 'Catalytic Converter') {
        var cloneData1 = json
            .decode(cloneData['disassmblingInformation'])
            .map((e) => e.toString())
            .toList();
        // print(cloneData);
        // print(cloneData[0].runtimeType);
        if (cloneData1 != null) {
          List<String> stringList = cloneData1.cast<String>().toList();
          cloneData['disassmblingInformation'] = stringList;
        }
        print(cloneData);
        // imageFileDir.value = orderDetail['imageFileDir'].replaceAll('"', "");
      } else {
        // cloneData['disassmblingInformation'] = <String>[];
      }
      wreckedData.value = cloneData;
    }
  }

  RxBool isEdit = false.obs;
  RxList<String> imageFileDir = <String>[].obs;
  changeImageFileDir(List<String> XFiles) {
    print(XFiles);
    imageFileDir.value = XFiles;
    imageFileDir.refresh();
  }

  changeCC(List<String> XFiles) {
    print(XFiles);
    wreckedData.value['disassmblingInformation'] = XFiles;
    wreckedData.refresh();
  }



}
