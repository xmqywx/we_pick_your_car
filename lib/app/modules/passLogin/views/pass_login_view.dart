import 'package:car_wrecker/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:car_wrecker/app/models/message.dart';
import '../../../services/screen_adapter.dart';
import '../../../widget/logo.dart';
import '../../../widget/passButton.dart';
import '../../../widget/passTextField.dart';
import '../../../widget/userAgreement.dart';
import '../controllers/pass_login_controller.dart';
import '../../tabs/controllers/tabs_controller.dart';
import '../../../widget/toast.dart';
import '../../../color/colors.dart';

class PassLoginView extends GetView<PassLoginController> {
  const PassLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // actions: [TextButton(onPressed: () {}, child: Text("Help"))],
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdapter.width(40)),
        children: [
          const Logo(),
          //请输入用户名
          PassTextFiled(
              controller: controller.usernameController,
              hintText: "Please enter your user name",
              label: "User name",
              onChanged: (value) {
                print(value);
              }),

          PassTextFiled(
              controller: controller.passController,
              hintText: "Please enter your password",
              label: "Password",
              isPassWord: true,
              onChanged: (value) {
                print(value);
              }),
          //用户协议
          // const UserAgreement(),
          //登录按钮
          SizedBox(
              // height: ScreenAdapter.height(10),
              ),
          PassButton(
              text: "Login",
              btnColor: AppColors.logoBgc,
              isLoading: controller.isLoading.value,
              onPressed: () async {
                // print("获取验证码");
                if (controller.usernameController.text == "") {
                  showCustomSnackbar(
                      status: '3',
                      message: "Please enter your correct username");
                } else if (controller.passController.text.length < 6) {
                  showCustomSnackbar(
                      status: '3',
                      message: "Password length cannot be less than 6 digits");
                } else {
                  MessageModel result = await controller.doLogin();
                  if (result.success) {
                    // await Get.find<TabsController>().getUserInfo();
                    // await Get.find<UserController>().getUserInfo();
                    showCustomSnackbar(message: 'Login successful.');
                    Get.offAllNamed("/tabs");
                  } else {
                    showCustomSnackbar(
                      message: result.message,
                      status: '3',
                    );
                  }
                }
              }),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     TextButton(onPressed: () {}, child: Text("Forgot password")),
          //   ],
          // )
        ],
      ),
    ));
  }
}
