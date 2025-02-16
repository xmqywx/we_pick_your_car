import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
    const PretreatmentView(),
    const CompletedView(),
    const UnaccomplishedView(),
  ];
  final count = 0.obs;




  void increment() => count.value++;
}
