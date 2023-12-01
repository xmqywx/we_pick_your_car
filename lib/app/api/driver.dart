import '../services/https_client.dart';
import '../widget/toast.dart';

HttpsClient httpsClient = HttpsClient();

Future apiGetJobAll(data) async {
  // {
  //   "jobID": 693,
  //   "orderID": 687
  // }
  return await httpsClient.post("/admin/job/info/get_job_all", data: data);
}

Future apiUpdateJobAll(data) async {
  // {jobDetail: any, orderDetail: any, customerDetail: any, carDetail: any, secondaryPersonDetail: any}
  return await httpsClient.post("/admin/job/info/update_job_order", data: data);
}

Future handleApi(data) async {
  var response = await data['api'](data['payload']);
  if (response != null) {
    if (response.data['message'] == 'success') {
      return response.data['data'];
    } else {
      showCustomSnackbar(
          message: 'Request failed, ' + response.data['message'], status: '3');
      return null;
    }
  } else {
    showCustomSnackbar(
        message: 'Request failed, please check network connection.',
        status: '3');
    return null;
  }
}
