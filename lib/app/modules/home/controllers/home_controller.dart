
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../tabs/controllers/tabs_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../../controllers/is_loading_controller.dart';
// import '../../../templete/scheduling.dart';

class HomeController extends GetxController {
  UserController userController = Get.find<UserController>();
  final IsLoadingController isLoadingController =
      Get.find<IsLoadingController>();
  //浮动导航开关
  RxBool flag = false.obs;
  //ScrollController
  final ScrollController scrollController = ScrollController();
  final TabsController myController = Get.find<TabsController>();
  //滑动到300时触发
  RxBool visiFlag = true.obs;
  //盒子透明度
  RxDouble containerOpacity = 1.0.obs;
  RxBool changFlag = false.obs;

  final count = 0.obs;
  void _scrollToOffset(double offset) {
    scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  final GlobalKey tableKey = GlobalKey();

  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    //监听滚动条滚动事件
    // void scrollControllerListener() {
    //   scrollController.addListener(() {
    //     if (scrollController.position.pixels > ScreenAdapter.height(1) &&
    //         scrollController.position.pixels < ScreenAdapter.height(150)) {
    //       double _opacity =
    //           1 - scrollController.position.pixels / ScreenAdapter.height(150);
    //       if (_opacity > 1.0) {
    //         _opacity = 1.0;
    //       } else if (_opacity < 0) {
    //         _opacity = 0;
    //       }
    //       containerOpacity.value = _opacity;
    //       print(_opacity);
    //     }
    //     if (scrollController.position.pixels > 1) {
    //       if (flag.value == false) {
    //         print("position.pixels > 10");
    //         flag.value = true;
    //       }
    //     }
    //     if (scrollController.position.pixels < 10) {
    //       if (flag.value == true) {
    //         print("position.pixels < 10");
    //         flag.value = false;
    //       }
    //     }
    //     if (scrollController.position.pixels > ScreenAdapter.height(200)) {
    //       // _scrollToOffset(216);
    //       if (visiFlag == true) {
    //         visiFlag.value = false;
    //       }
    //     }
    //     if (scrollController.position.pixels <= ScreenAdapter.height(200)) {
    //       if (visiFlag == false) {
    //         visiFlag.value = true;
    //       }
    //     }
    //   });
    // }

    // scrollControllerListener();
    isLoading.value = true;
    await myController.initializationList();
    await myController.initializationJobViewList();
    isLoading.value = false;
    // changFlag.value = !changFlag.value;

    // final tableComplexExample = tableKey.currentState;
    // if (tableComplexExample != null) {
    //   tableComplexExample.setState(() {});
    //   // tableComplexExample.initSelectedDays();
    // }
  }

  //handleRefresh

  Future<void> handleRefresh() async {
    isLoading.value = true;
    await myController.initializationList();
    await myController.initializationJobViewList();
    changFlag.value = !changFlag.value;
    isLoading.value = false;
  }



  void increment() => count.value++;
}
