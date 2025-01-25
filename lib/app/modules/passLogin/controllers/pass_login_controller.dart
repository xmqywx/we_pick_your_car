import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/https_client.dart';
import '../../../models/message.dart';
import '../../../services/storage.dart';
import '../../user/controllers/user_controller.dart';
import '../../tabs/controllers/tabs_controller.dart';

class PassLoginController extends GetxController with WidgetsBindingObserver {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  UserController userController = Get.find<UserController>();
  HttpsClient httpsClient = HttpsClient();
  TabsController tabsController = Get.find<TabsController>();
  RxBool isKeyboardOpen = false.obs; // 添加键盘状态
  RxDouble keyboardHeight = 0.0.obs; // 添加键盘高度
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // 添加观察者
  }

  @override
  void onClose() async {
    WidgetsBinding.instance.removeObserver(this); // 移除观察者
    //状态管理 更新userController.getUserInfo
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardOpen.value = bottomInset > 0.0; // 更新键盘状态
    keyboardHeight.value = bottomInset; // 更新键盘高度
  }

  RxBool isLoading = false.obs;

  Future<MessageModel> doLogin() async {
    try {
      isLoading.value = true;
      var response = await httpsClient.post("/admin/base/open/login", data: {
        "username": usernameController.text,
        "password": passController.text,
      });

      isLoading.value = false;

      if (response != null) {
        print(response);
        if (response.data["message"] == "success") {
          //保存用户信息
          await Storage.setData("token", response.data["data"]["token"],
              expires: response.data["data"]["expire"]);
          await Storage.setData(
              "refreshToken", response.data["data"]["refreshToken"],
              expires: response.data["data"]["refreshExpire"]);
          await tabsController.getUserInfo();
          await userController.getUserInfo();
          // await tabsController.getJobList();
          // await tabsController.getOrderList();
          // await tabsController.initializationList();
          return MessageModel(message: "Login success", success: true);
        }

        if (response.data["message"] == "Incorrect account or password~") {
          return MessageModel(
              message: "Incorrect user name or password~", success: false);
        }
        return MessageModel(message: response.data["message"], success: false);
      } else {
        return MessageModel(message: "Internet error", success: false);
      }
    } catch (e) {
      return MessageModel(message: e.toString(), success: false);
    }
  }
}
