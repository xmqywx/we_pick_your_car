import '../services/https_client.dart';
import '../models/component_model.dart';

HttpsClient httpsClient = HttpsClient();

Future apiGetContainerPage(data) async {
  return await httpsClient.post('/admin/container/base/page', data: data);
}

Future apiGetContainerInfo({required int id}) async {
  return await httpsClient.get("/admin/container/base/info?id=${id}");
}

Future apiGetComponentPageByContainerId(data) async {
  return await httpsClient.post('/admin/car/carWrecked/page', data: data);
}

Future apiDeleteContainerById(data) async {
  return await httpsClient.post('/admin/container/base/delete', data: data);
}

Future apiAddContainer(data) async {
  return await httpsClient.post('/admin/container/base/add', data: data);
}

Future apiUpdateContainerById(data) async {
  return await httpsClient.post('/admin/container/base/add', data: data);
}

Future apiGetComponentInfo({required String partId}) async {
  return await httpsClient
      .post("/admin/car/carWrecked/infoByDn", data: {"partId": partId});
}

Future apiUpdateComponent(data) async {
  return await httpsClient.post("/admin/car/carWrecked/update", data: data);
}

Future apiAddToComponent(data) async {
  return await httpsClient.post("/admin/car/carWrecked/putToContainer",
      data: data);
}

Future apiDeleteComponentFromThisContainer(data) async {
  return await httpsClient.post("/admin/car/carWrecked/moveOutFromContainer",
      data: data);
}

Future checkIsUniqueContainerNumber(data) async {
  //  {containerNumber: "asdf"}
  return await httpsClient
      .post("/admin/container/base/checkIsUniqueContainerNumber", data: data);
}

Future checkIsUniqueSealedNumber(data) async {
  //  {sealNumber: "asdf"}
  return await httpsClient
      .post("/admin/container/base/checkIsUniqueSealedNumber", data: data);
}

Future apiGetWreckerContainerAndComponents(data) async {
  //  {sealNumber: "asdf"}
  return await httpsClient.post("/admin/container/base/get_wrecker_container",
      data: data);
}
