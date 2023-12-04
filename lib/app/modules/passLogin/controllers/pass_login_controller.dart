import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/https_client.dart';
import '../../../models/message.dart';
import '../../../services/storage.dart';
import '../../user/controllers/user_controller.dart';
import '../../tabs/controllers/tabs_controller.dart';

class PassLoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  UserController userController = Get.find<UserController>();
  HttpsClient httpsClient = HttpsClient();
  TabsController tabsController = Get.find<TabsController>();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() async {
    //状态管理 更新userController.getUserInfo

    super.onClose();
  }

  Future<MessageModel> doLogin() async {
    var response = await httpsClient.post("/admin/base/open/login", data: {
      "username": usernameController.text,
      "password": passController.text,
    });

    if (response != null) {
      print(response);
      if (response.data["message"] == "success") {
        //保存用户信息
        await Storage.setData("token", response.data["data"]["token"]);
        await Storage.setData(
            "refreshToken", response.data["data"]["refreshToken"]);
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
  }
}
