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
          backgroundColor: Color(0xFF002132),
          appBar: AppBar(
            backgroundColor: Color(0xFF002132),
            elevation: 0,
            // actions: [TextButton(onPressed: () {}, child: Text("Help"))],
          ),
          body: ListView(
            padding: EdgeInsets.all(ScreenAdapter.width(40)),
            children: [
              Logo(),
              //请输入用户名
              PassTextFiled(
                controller: controller.usernameController,
                hintText: "Please enter your user name",
                label: "User name",
                onChanged: (value) {
                  print(value);
                },
                textColor: Colors.white, // Set text color to white
                hintTextColor:
                    Colors.white70, // Set hint text color to a lighter shade
              ),

              PassTextFiled(
                controller: controller.passController,
                hintText: "Please enter your password",
                label: "Password",
                isPassWord: true,
                onChanged: (value) {
                  print(value);
                },
                textColor: Colors.white, // Set text color to white
                hintTextColor:
                    Colors.white70, // Set hint text color to a lighter shade
              ),
              //用户协议
              // const UserAgreement(),
              //登录按钮
              SizedBox(
                  // height: ScreenAdapter.height(10),
                  ),
              PassButton(
                  text: "Login",
                  btnColor: AppColors.darkGreyColor,
                  textColor: Colors.white, // Set button text color to white
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
                          message:
                              "Password length cannot be less than 6 digits");
                    } else {
                      MessageModel result = await controller.doLogin();
                      if (result.success) {
                        // await Get.find<TabsController>().getUserInfo();
                        // await Get.find<UserController>().getUserInfo();
                        await Get.offAllNamed("/tabs");
                        showCustomSnackbar(message: 'Login successful.');
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
