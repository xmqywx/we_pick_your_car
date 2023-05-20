import '../services/https_client.dart';

HttpsClient httpsClient = HttpsClient();

Future apiGetIdOrder(id) async {
  return await httpsClient.post('/admin/order/info/page', data: {"id": id});
}

Future apiSendInvoice(
    {required String name,
    required int id,
    required String price,
    required String email}) async {
  return await httpsClient.post('/admin/order/action/sendEmail',
      data: {"name": name, "price": price, "id": id, "email": email});
}

Future updateOrder(data) async {
  return await httpsClient.post('/admin/order/info/update', data: data);
}
