import 'package:get/get.dart';

import '../stats_model.dart';

class StatsProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Stats.fromJson(map);
      if (map is List) return map.map((item) => Stats.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Stats?> getStats(int id) async {
    final response = await get('stats/$id');
    return response.body;
  }

  Future<Response<Stats>> postStats(Stats stats) async =>
      await post('stats', stats);
  Future<Response> deleteStats(int id) async => await delete('stats/$id');
}
