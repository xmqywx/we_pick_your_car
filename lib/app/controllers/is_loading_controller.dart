import 'package:get/get.dart';

/// 怎么都是false ?????
/// 不清楚 去http_request
/// 你再get 添加了很多这个
/// 但是对它的操只有http里面，懂
/// 在js我是这么做过的loading，这里不行么
/// put 一个，用find拿就是同一个 什么意思
///
///
/// 你这个控制器是全局用一个，还是单独使用？？？？
///
/// 如果是全局使用一个，你只需要put 一次
///
/// 如果单独使用，put 的时候需要加tag
///
///
/// 懂我意思？
///
/// 正常来说，应该全局用一个吧
/// 不一定，还得看情况，
/// 就当前的loading  用一个？
/// 现在是你的loading最终控制都在http中对吧
/// 嗯
/// 但是现在每个界面都put 了
/// 把界面的put
/// 我演示一下
///
///
class IsLoadingController extends GetxController {
  //TODO: Implement IsLoadingController
  RxBool isLoading = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
