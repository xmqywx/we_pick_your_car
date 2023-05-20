import 'package:flutter/material.dart';
import './passButton.dart';
import 'package:get/get.dart';

class NoLogin extends StatelessWidget {
  const NoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        // height: 400,
        child: Column(children: [
          Image.asset(
            "assets/images/noData.png",
            // width: double.infinity,
            // height: 300,
          ),
          // Text(
          //   "You haven't signed in yet",
          //   style: TextStyle(fontSize: 16),
          // ),
          // PassButton(
          //   onPressed: () {
          //     Get.toNamed("/pass_login");
          //   },
          //   text: "To login",
          // )
        ]),
      ),
    );
  }
}
