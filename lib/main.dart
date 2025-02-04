import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/controllers/is_loading_controller.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import './app/color/colors.dart';
import './app/services/storage.dart';
import './app/api/user.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //配置透明的状态栏
  SystemUiOverlayStyle systemUiOverlayStyle =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  Get.put(IsLoadingController());
  // Timer.periodic(Duration(milliseconds: 300), (Timer t) async {
  //   bool tokenExpired = await Storage.isExpired("token");
  //   if (tokenExpired) {
  //     // 如果token过期，触发apiGetToken函数
  //     String? refreshToken = await Storage.getData('refreshToken');
  //     var response = await apiGetToken(refreshToken);
  //     if (response != null) {
  //       print(response);
  //       if (response.data["message"] == "success") {
  //         //保存用户信息
  //         await Storage.setData("token", response.data["data"]["token"], expires: response.data["data"]["expire"]);
  //         await Storage.setData(
  //             "refreshToken", response.data["data"]["refreshToken"], expires: response.data["data"]["refreshExpire"]);
  //       }
  //     }
  //   }
  // });
  // Get.put(AuthMiddleware());
  runApp(ScreenUtilInit(
    designSize: const Size(1080, 2400), //设计稿的宽度和高度 px
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {
      return GestureDetector(
        onTap: () {
          // 取消当前焦点，隐藏键盘
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        onPanUpdate: (details) {
          // 处理滑动手势，取消焦点
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        onPanDown: (details) {
          // 处理滑动手势开始，取消焦点
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          title: 'Apexpoint',
          theme: ThemeData(
            primarySwatch: AppColors.primarySwatch,
            fontFamily: "Bebas",
          ),
          getPages: AppPages.routes,
        ),
      );
    },
  ));
}
