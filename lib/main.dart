import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/controllers/is_loading_controller.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import './app/color/colors.dart';

void main() {
  //配置透明的状态栏
  SystemUiOverlayStyle systemUiOverlayStyle =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  Get.put(IsLoadingController());
  // Get.put(AuthMiddleware());
  runApp(ScreenUtilInit(
      designSize: const Size(1080, 2400), //设计稿的宽度和高度 px
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          title: 'We pick your car',
          theme: ThemeData(
              primarySwatch: AppColors.primarySwatch, fontFamily: "Bebas"),
          getPages: AppPages.routes,
        );
      }));
}
