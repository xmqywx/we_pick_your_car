import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../views/task_list_view.dart';
import '../../have_in_hand/views/have_in_hand_view.dart';
import '../../pretreatment/views/pretreatment_view.dart';
import '../../unaccomplished/views/unaccomplished_view.dart';
import '../../completed/views/completed_view.dart';
import '../../user/controllers/user_controller.dart';

class TaskListController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement TaskListController
  UserController userController = Get.find<UserController>();
  late TabController tabController;
  final List<Widget> pages = [
    HaveInHandView(),
    PretreatmentView(),
    CompletedView(),
    UnaccomplishedView(),
  ];
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // tabController = TabController(length: 4, vsync: this);
    // tabController.addListener(() {
    //   if (tabController.animation!.value == tabController.index) {
    //     print(tabController.index); //获取点击或滑动页面的索引值
    //   }
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
