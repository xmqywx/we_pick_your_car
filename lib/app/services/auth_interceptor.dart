import 'package:dio/dio.dart';
import './storage.dart';
import '../api/user.dart';
import 'dart:async';
import '../widget/toast.dart';
import 'package:get/get.dart' as Get;
import '../modules/user/controllers/user_controller.dart';

UserController userController = Get.Get.find<UserController>();
class AuthInterceptor extends Interceptor {
  static Dio dio = Dio();
  static Timer? _timer;
  static bool _isRefreshingToken = false; // 添加标志位

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) && !_isRefreshingToken) {
      _isRefreshingToken = true; // 开始刷新token，设置标志位
      String? refreshToken = await Storage.getData('refreshToken');
      var response = await apiGetToken(refreshToken);
      if (response != null && response.data["message"] == "success") {
        // 保存新的token和refreshToken
        await Storage.setData("token", response.data["data"]["token"], expires: response.data["data"]["expire"]);
        await Storage.setData("refreshToken", response.data["data"]["refreshToken"], expires: response.data["data"]["refreshExpire"]);
        // 重试原始请求
        RequestOptions requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = '${response.data["data"]["token"]}';
        dio.fetch(requestOptions).then(
          (r) {
            handler.resolve(r);
          },
          onError: (e) {
            // userController.loginOut();
            // showCustomSnackbar(message: "Token expires", status: '3');
            handler.reject(e);
          },
        ).whenComplete(() => _isRefreshingToken = false); // 刷新完成，无论成功与否，重置标志位
        
      } else if((err.response?.statusCode == 401 || err.response?.statusCode == 403) && _isRefreshingToken) {
        // 如果刷新token失败（可能是refreshToken也过期了），处理登录失效逻辑
        _isRefreshingToken = false; // 重置标志位
        userController.loginOut();
        showCustomSnackbar(message: "Token expires", status: '3');
        handler.next(err); // 使用next而不是reject，以避免再次触发onError
      } else {
        handler.next(err);
      }
      return;
    }
    super.onError(err, handler);
  }
}