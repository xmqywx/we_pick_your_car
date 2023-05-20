// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import '../controllers/have_in_hand_controller.dart';

// class HaveInHandView extends GetView<HaveInHandController> {
//   const HaveInHandView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const Center(
//         child: Text(
//           'HaveInHandView is working',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
// ignore: file_names
import 'package:flutter/material.dart';
import '../../../templete/in_complete.dart';
import '../../../templete/empty.dart';
import '../../../data/have_in_hand_list.dart';
import '../../../templete/have_in_hand_templete.dart';

class HaveInHandView extends StatefulWidget {
  List list = [];
  HaveInHandView({super.key}) {
    list = initHaveInHandList().map((value) {
      return HaveInHandTemplete(
        arguments: value,
      );
    }).toList();
  }

  @override
  State<HaveInHandView> createState() => _HaveInHandViewState();
}

class _HaveInHandViewState extends State<HaveInHandView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return widget.list[index];
            }));
  }
}
