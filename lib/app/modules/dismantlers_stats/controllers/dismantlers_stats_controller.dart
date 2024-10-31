import 'package:get/get.dart';
import '../../../api/dismantler.dart';
import '../../../services/storage.dart';
import '../stats_model.dart';

class DismantlersStatsController extends GetxController {
  Rx<Stats> carCount = Stats().obs;
  Future<void> handleRefresh() async {
    await getStats();
  }

  getStats() async {
    final userinfo = await Storage.getData('userinfo');
    final departmentId = userinfo['departmentId'];
    var response = await apiGetcarsPartsStats({"departmentId": departmentId});

    if (response != null && response.data['message'] == 'success') {
      final data = response.data['data'];
      carCount.value = Stats.fromJson(data);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getStats();
  }
}
