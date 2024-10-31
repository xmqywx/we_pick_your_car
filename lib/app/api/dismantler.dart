import '../services/https_client.dart';

HttpsClient httpsClient = HttpsClient();

Future apiGetcarsPartsStats(data) async {
  return await httpsClient.post('/admin/base/comm/cars_parts_stats',
      data: data);
}
