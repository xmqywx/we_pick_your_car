import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:car_wrecker/app/widget/toast.dart';
import '../../../api/wrecker.dart';
import 'package:scan/scan.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../services/storage.dart';

class DismantlersController extends GetxController {
  //TODO: Implement DismantlersController
  RxString vehicleLabel = ''.obs;
  RxString vehicleUrl = ''.obs;
  late final WebViewController webcontroller;

  @override
  void onInit() {
    super.onInit();
    webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 扫码

  ScanController scanController = ScanController();
  Rx<String?> scanResult = ''.obs;

  scanQRCode() async {
    try {
      Get.to(Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            child: ScanView(
              controller: scanController,
              scanAreaScale: 0.7,
              scanLineColor: Colors.green.shade400,
              onCapture: (data) {
                parseScanUrl(data);
                Get.back();
                handleScanResult(vehicleUrl.value);
              },
            ),
          )));
    } catch (e) {
      print('扫描二维码出错：$e');
      showCustomSnackbar(
          message: 'Scanning failed, please scan the correct QR code.',
          status: '3');
      return null;
    }
  }

  scanPickImage() async {
    try {
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
          if (str == null) {
            showCustomSnackbar(
                message: 'Scanning failed, please scan the correct QR code.',
                status: '3');
            return;
          }
          parseScanUrl(str);
          handleScanResult(vehicleUrl.value);
        } else {
          // 如果选择的文件不是图片，显示提示
          showCustomSnackbar(
            message: 'Please select only image files.',
            status: '3',
          );
        }
      }
    } catch (e) {
      print('扫描二维码出错：$e');
      showCustomSnackbar(
          message: 'Scanning failed, please scan the correct QR code.',
          status: '3');
      return null;
    }
  }

  parseScanUrl(url) {
    try {
      vehicleUrl.value = url;
      final uri = Uri.parse(url);
      final lnValue = uri.queryParameters['ln'];
      vehicleLabel.value = lnValue ?? '';
    } catch (e) {
      vehicleUrl.value = '';
      vehicleLabel.value = '';
    }
  }

  handleScanResult(v) async {
    String? token = await Storage.getData('token');
    Uri baseUri = Uri.parse(v);

    Uri uriWithToken = baseUri.replace(queryParameters: {
      ...baseUri.queryParameters,
      'token': token,
    });
    webcontroller..loadRequest(uriWithToken);
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

  Future<void> handleToRefresh() async {}
  handleClearUri() {
    vehicleUrl.value = '';
    vehicleLabel.value = '';
  }

  handleReloadWebView() {
    webcontroller.reload();
  }
}
