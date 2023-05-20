import 'package:get/get.dart';
import '../../../services/storage.dart';
import '../../../models/user_model.dart';
import '../../../services/userServices.dart';

class UserController extends GetxController {
  //TODO: Implement UserController
  RxBool isLogin = false.obs;
  var userInfo = UserModel().obs;
  Future printToken() async {
    final token = await Storage.getData("token");
    print(token);
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserInfo();
    print(isLogin.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getUserInfo() async {
    var tempLoginState = await UserServices.getUserLoginState();
    isLogin.value = tempLoginState;
    Map<String, dynamic> info = await UserServices.getUserInfo();
    print(info);
    if (info.isNotEmpty) {
      userInfo.value = UserModel.fromJson(info);
    }
  }

  loginOut() {
    UserServices.loginOut();
    isLogin.value = false;
    //把信息值为空
    userInfo.value = UserModel();

    /// 跑
    //退出登录，去到登录页,shishi
    // Get.offAllNamed("/pass_login");
  }
}
