import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../templete/in_complete.dart';
import '../../../data/task_list.dart';

class CompletedController extends GetxController {
  //TODO: Implement CompletedController
  RxList<Widget> initListView() {
    var initList = initTaskList();
    RxList<Widget> list = initList
        .map((value) {
          return InComplete(
              time: "${value['time_of_appointment']}",
              end_position: "${value['end_position']}",
              start_position: "${value['start_position']}",
              cost: "${value['cost']}",
              status: "${value['status']}",
              detail_info: value);
        })
        .toList()
        .obs;
    return list;
  }

  final count = 0.obs;



  void increment() => count.value++;
}
