// import 'package:flutter/material.dart';
// import '../../../templete/in_complete.dart';
// import '../../../data/task_list.dart';

// class CompletedView extends StatefulWidget {
//   const CompletedView({super.key});

//   @override
//   State<CompletedView> createState() => _CompletedViewState();
// }

// class _CompletedViewState extends State<CompletedView> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(children: widget._initListView());
//   }
// }
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/completed_controller.dart';

class CompletedView extends GetView<CompletedController> {
  const CompletedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(CompletedController());
    return Obx(() => controller.initListView().isNotEmpty
        ? ListView(children: controller.initListView())
        : const Text(""));
  }
}
