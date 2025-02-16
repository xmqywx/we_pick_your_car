import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../widget/custom_form.dart';
import '../../../widget/passButton.dart';
import '../../../color/colors.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: const Text(
              "Register",
              style: TextStyle(
                fontSize: 24, // 字体大小
                fontWeight: FontWeight.bold, // 字体加粗
                letterSpacing: 1.5, // 字母间距
              ),
            ),
            elevation: 0,
            // actions: [TextButton(onPressed: () {}, child: Text("Help"))],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DynamicForm(
                    formKey: controller.formKey,
                    formFields: controller.formList,
                    formData: controller.formData,
                    formRules: controller.formFieldJudge.value,
                    formDataChange: (key, value) {
                      controller.formData[key] = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  PassButton(
                    text: "Register",
                    btnColor: AppColors.logoBgc,
                    textColor: Colors.white,
                    isLoading: controller.isLoading.value,
                    onPressed: () async {
                      await controller.register();
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed("/pass_login"); // 跳转到登录页面
                    },
                    child: const Text("Already have an account? Login here."),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
