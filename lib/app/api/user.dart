import '../services/https_client.dart';

HttpsClient httpsClient = HttpsClient();

Future apiGetToken(refreshToken) async {
  return await httpsClient
      .get('/admin/base/open/refreshToken?refreshToken=$refreshToken');
}
