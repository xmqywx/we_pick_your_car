import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../templete/calendar_templete.dart';
import '../controllers/task_list_controller.dart';
import 'package:calendar_view/calendar_view.dart';
import '../../../widget/no_login.dart';
import '../../../widget/passButton.dart';
import '../../pretreatment/views/pretreatment_view.dart';

class TaskListView extends GetView<TaskListController> {
  const TaskListView({Key? key}) : super(key: key);
  Widget _NoLogin() {
    return Column(
      children: [
        NoLogin(),
        Text("You haven't signed yet"),
        TextButton(
          child: Text("To login"),
          onPressed: () {
            Get.toNamed("/pass_login");
          },
        )
      ],
    );
  }

  Widget _SignedIn() {
    // return TabBarView(
    //     controller: controller.tabController, children: controller.pages);
    return PretreatmentView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   elevation: 0,
        //   // title: TabBar(
        //   //   controller: controller.tabController,
        //   //   indicatorSize: TabBarIndicatorSize.label,
        //   //   isScrollable: true,
        //   //   tabs: const [
        //   //     Tab(
        //   //       child: Text(
        //   //         "Have in hand",
        //   //         style: TextStyle(fontSize: 14),
        //   //       ),
        //   //     ),
        //   //     Tab(
        //   //       child: Text(
        //   //         "Pretreatment",
        //   //         style: TextStyle(fontSize: 14),
        //   //       ),
        //   //     ),
        //   //     Tab(
        //   //       child: Text(
        //   //         "Completed",
        //   //         style: TextStyle(fontSize: 14),
        //   //       ),
        //   //     ),
        //   //     Tab(
        //   //       child: Text(
        //   //         "Unaccomplished",
        //   //         style: TextStyle(fontSize: 14),
        //   //       ),
        //   //     ),
        //   //   ],
        //   // ),
        //   title: SizedBox(
        //     // height: ScreenAdapter.height(100),
        //     child: Text("Job list"),
        //   ),
        //   centerTitle: true,
        // ),
        // body: CalendarView(
        //   minDate: DateTime.now().subtract(Duration(days: 365)),
        //   maxDate: DateTime.now().add(Duration(days: 365)),
        //   initialDate: DateTime.now(),
        //   onDateSelected: (date) {
        //     // 处理日期选择事件
        //   },
        // ),
        body: Container(
            child: Obx(
          () => controller.userController.isLogin.value
              ? _SignedIn()
              : _NoLogin(),
        )));
  }
}
