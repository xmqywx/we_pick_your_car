
import "./storage.dart";
import 'package:get/get.dart';

class UserServices {
  static Future<Map<String, dynamic>> getUserInfo() async {
    Map<String, dynamic>? userInfo = await Storage.getData("userinfo");
    if (userInfo != null) {
      return userInfo;
    } else {
      return {};
    }
  }

  static Future<bool> getUserLoginState() async {
    Map userInfo = await getUserInfo();
    if (userInfo.isNotEmpty && userInfo["username"] != "") {
      return true;
    } else {
      return false;
    }
  }

  static loginOut() async {
    Storage.removeData("token");
    Storage.removeData("userinfo");
    print(Get.currentRoute);
    if (Get.currentRoute == "/pass_login") {
      return;
    }

    /// chuanru销毁一下 loading的？还是就是那个
    /// 刚刚没有加载数据，是因为没有重新加载，懂我意思
    /// 数据加载的那个控制器，懂我？？？哈哈哈
    //Get.delete<>();
    //

    ///
    Get.offAllNamed("/pass_login");
  }
}
