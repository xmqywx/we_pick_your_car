import '../services/https_client.dart';

HttpsClient httpsClient = HttpsClient();

Future apiGetJobList(data) async {
  return await httpsClient.post('/admin/order/info/list', data: data);
}
