import 'package:get/get.dart';

import '../controllers/dismantlers_stats_controller.dart';

class DismantlersStatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DismantlersStatsController>(
      () => DismantlersStatsController(),
    );
  }
}
