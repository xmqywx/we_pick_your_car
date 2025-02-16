import 'package:get/get.dart';
import '../../user/controllers/user_controller.dart';
import '../../../services/https_client.dart';
import '../../../widget/toast.dart';
import '../../../api/user.dart';

class PersonalCenterController extends GetxController {
  //TODO: Implement PersonalCenterController

  UserController userController = Get.find<UserController>();
  HttpsClient httpsClient = HttpsClient();
  final password = "".obs;
  passChange(value) {
    password.value = value;
  }

  updateInfo() async {
    if (password.value.isEmpty) {
      showCustomSnackbar(
          status: '3', message: "The new password cannot be empty");
      return false;
    } else if (password.value.length < 6) {
      showCustomSnackbar(
          status: '3', message: "Password length cannot be less than 6 digits");
      return false;
    }
    var response = await apiUpdateUser(
        {"id": userController.userInfo.value.id, "password": password.value});
    if (response != null && response.data['message'] == 'success') {
      print("update success");
      userController.loginOut();
      showCustomSnackbar(message: "Password modified successfully.");

      return true;
    } else {
      print('Token expired or network error');
      return false;
    }
  }

  deleteAccount() async {
    var response = await apiLogOff(userController.userInfo.value.id);

    if (response != null && response.data['message'] == 'success') {
      userController.loginOut();
      showCustomSnackbar(message: "Account deletion request is received. Your request will be processed within 2 weeks.");

      return true;
    } else {
      print('Token expired or network error');
      return false;
    }
  }

  final count = 0.obs;



  void increment() => count.value++;
}
