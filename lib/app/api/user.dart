import '../services/https_client.dart';

HttpsClient httpsClient = HttpsClient();

Future apiGetToken(refreshToken) async {
  return await httpsClient
      .get('/admin/base/open/refreshToken?refreshToken=$refreshToken');
}

Future apiGetRoleDepartmentList() async {
  return await httpsClient.get('/admin/base/open/role_department_list');
}

Future apiReg(data) async {
  return await httpsClient.post('/admin/base/open/create_user', data: data);
}
