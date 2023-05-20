// import 'package:flutter/material.dart';
// import '../../../templete/in_complete.dart';
// import '../../../data/task_list.dart';

// class UnaccomplishedView extends StatefulWidget {
//   const UnaccomplishedView({super.key});

//   @override
//   State<UnaccomplishedView> createState() => _UnaccomplishedViewState();
// }

// class _UnaccomplishedViewState extends State<UnaccomplishedView> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(children: widget._initListView());
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/unaccomplished_controller.dart';

class UnaccomplishedView extends GetView<UnaccomplishedController> {
  const UnaccomplishedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(UnaccomplishedController());
    return Obx(() => controller.initListView().isNotEmpty
        ? ListView(children: controller.initListView())
        : const Text(""));
  }
}
