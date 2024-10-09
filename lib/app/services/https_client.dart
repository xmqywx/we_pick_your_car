import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as Get;
import '../modules/user/controllers/user_controller.dart';
import './storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import '../controllers/is_loading_controller.dart';
import '../widget/toast.dart';
import './auth_interceptor.dart';

UserController userController = Get.Get.find<UserController>();
// final IsLoadingController isLoadingController =
//     Get.Get.find<IsLoadingController>();

class HttpsClient {
  static String domain = "https://apexpoint.com.au/api/";
  // static String domain = "http://192.168.101.21:9000/dev/";

  static Dio dio = Dio();
  static int _loadingCount = 0; // 记录当前显示的加载动画数量
  static Timer? _timer;

  HttpsClient() {
    dio.options.baseUrl = domain;
    dio.interceptors.add(AuthInterceptor());
    dio.options.connectTimeout = 20000;
    dio.options.receiveTimeout = 20000;
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await Storage.getData('token');
        if (token != null) {
          options.headers['Authorization'] = token;
        }
        // if (_loadingCount <= 0) {
        //   // Get.Get.dialog(
        //   //   Center(
        //   //     child: CircularProgressIndicator(),
        //   //   ),
        //   //   barrierDismissible: false,
        //   // );

        //   isLoadingController.isLoading.value = true;
        // }
        // _loadingCount++;
        handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        _loadingCount--;
        if (_loadingCount <= 0) {
          // Get.Get.back();
          // isLoadingController.isLoading.value = false;
          makeRequest();
        }
        if (response.statusCode == 401) {
          userController.loginOut();
          showCustomSnackbar(message: "Token expires", status: '3');
        }
        return handler.next(response);
      },
      onError: (DioError error, ErrorInterceptorHandler handler) async {
        print(error);
        _loadingCount--;
        if (_loadingCount <= 0) {
          // Get.Get.back();
          makeRequest();
          // isLoadingController.isLoading.value = false;
        }
        // if (error.response?.statusCode == 401) {
        //   userController.loginOut();
        //   showCustomSnackbar(message: "Token expires 4444444", status: '3');
        // }
        return handler.next(error);
      },
    ));
  }

  Future get(apiUrl) async {
    try {
      var response = await dio.get(apiUrl);
      return response;
    } catch (e) {
      return null;
    }
  }

  Future uploadFile(String apiUrl, {required File file}) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.post(apiUrl, data: formData);
      return response;
    } catch (e) {
      // showCustomSnackbar(message: "$e", status: '3');
      print(e);
      return null;
    }
  }

  Future post(String apiUrl, {Map? data}) async {
    try {
      var response = await dio.post(apiUrl, data: data);
      return response;
    } catch (e) {
      print("======================= dio");
      print(e);
      print("======================= dio");
      return null;
    }
  }

  Future<void> makeRequest() async {
    // 发出请求，启动计时器
    // _timer = Timer(Duration(milliseconds: 500), () {
    //   // 在500毫秒后检查是否有其他请求在等待
    //   if (_loadingCount == 0) {
    //     // 没有其他请求，停止计时器并将isLoadingController.isLoading.value设置为false
    //     _timer?.cancel();
    //     isLoadingController.isLoading.value = false;
    //   }
    // });
  }

  static replaeUri(picUrl) {
    String tempUrl = domain + picUrl;
    return tempUrl.replaceAll("\\", "/");
  }
}
