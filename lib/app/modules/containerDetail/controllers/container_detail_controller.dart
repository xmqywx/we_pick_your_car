import 'package:car_wrecker/app/widget/toast.dart';
import 'package:get/get.dart';
import '../../../api/wrecker.dart';
import '../../../models/container_model.dart';
import 'package:flutter/material.dart';
import '../../../services/format_date.dart';

class ContainerDetailController extends GetxController {
  //TODO: Implement ContainerDetailController
  RxMap arguments = {}.obs;
  RxInt count = 1.obs;
  RxBool isEdit = false.obs;
  var containerInfo = ContainerModel().obs;
  RxList<Map<String, dynamic>> formList = RxList<Map<String, dynamic>>([]);
  ScrollController listScrollController = ScrollController();
  RxMap<String, dynamic> containerInfoForm = RxMap<String, dynamic>({});
  final formKey = GlobalKey<FormState>();
  formDataChange(key, value) {
    containerInfoForm.value[key] = value;
    containerInfoForm.refresh();
  }

  Future getContainerInfo() async {
    var response =
        await apiGetContainerInfo(id: arguments.value['containerValue']['id']);
    print(response);
    if (response != null && response.data['message'] == 'success') {
      return response.data['data'];
    } else {
      return {};
    }
  }

  Future handleApi(data) async {
    var response = await data['api'](data['payload']);
    if (response != null && response.data['message'] == 'success') {
      return response.data['data'];
    } else {
      return null;
    }
  }

  setContainerInfo() async {
    var response = await getContainerInfo();
    containerInfo.value = ContainerModel.fromJson(response);
    containerInfoForm.value = {
      "containerNumber": containerInfo.value.containerNumber,
      "startDeliverTime": containerInfo.value.startDeliverTime,
      "sealNumber": containerInfo.value.sealNumber,
      "status": containerInfo.value.status,
    };

    containerInfo.refresh();
  }

  setFormList() {
    formList.value = [
      {
        "label": "Container number",
        "prop": "containerNumber",
        "disabled": isEdit.value,
        "value": containerInfo.value.containerNumber ?? '',
        "component": {
          "type": "input",
          "placeholder": "Please input the container number.",
        },
        "rules": [
          {
            "require": true,
            "message": "Container number cannot be empty.",
          },
          if (!isEdit.value)
            {
              "validator": (containerNumber) async {
                var res = await handleApi({
                  "api": checkIsUniqueContainerNumber,
                  "payload": {"containerNumber": containerNumber}
                });
                print(1111111);
                if (res != null) {
                  if (res['isUnique']) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              },
              "message": "The container number has already been used.",
            },
        ],
      },
      {
        "label": "Commence date",
        "prop": "startDeliverTime",
        "value": containerInfo.value.startDeliverTime ?? '',
        "component": {
          "type": "datepicker",
          "placeholder": "Please input the container number.",
        },
        "rules": [
          {
            "require": true,
            "message": "Commence date cannot be empty.",
          },
        ],
      },
      {
        "label": "Seal",
        "value": false,
        "prop": "isSeal",
        "hidden": !isEdit.value,
        "component": {
          "type": "checkbox",
          "placeholder": "Please input the container number.",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [
          {
            "pattern": r'^[a-zA-Z]+$',
            "errorMessage": "Name should contain only alphabets",
          },
        ],
      },
      {
        "label": "Seal number",
        "prop": "sealNumber",
        "value": containerInfo.value.sealNumber ?? '',
        "hidden": !containerInfoForm.value['isSeal'],
        "component": {
          "type": "input",
          "placeholder": "Please input the container number.",
        },
        "rules": [
          {
            "require": true,
            "message": "Seal number cannot be empty.",
          },
        ],
      }
    ];
    formList.refresh();
  }

  Future<void> handleRefresh() async {}

  formSubmit() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      if (isEdit.value) {
        updateContainer();
      } else {
        addNewContainer();
      }
    }
  }

  containerDelete() async {
    var response = await apiDeleteContainerById({
      "ids": [arguments.value['containerValue']['id']]
    });
    if (response != null && response.data['message'] == 'success') {
      Get.until((route) => route.isFirst);
      if (arguments.value['refresh'] != null) {
        arguments.value['refresh']();
      }
      showCustomSnackbar(message: 'Successfully deleted.', status: '1');
    } else {
      showCustomSnackbar(
          message: 'Delete failed, please try again later.', status: '3');
    }
  }

  Future<void> alertDeleteContainerDialog() async {
    var result = await Get.dialog(
        AlertDialog(
          title: const Text("Prompt information!"),
          content:
              const Text("Are you sure you want to delete this container?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back(result: 'Cancel');
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Get.back(result: 'Ok');
              },
            )
          ],
        ),
        barrierDismissible: false);
    if (result == 'Ok') {
      containerDelete();
    }
  }

  addNewContainer() async {
    if (containerInfoForm.value['status'] == null) {
      containerInfoForm.value['status'] = 0;
    }
    var response = await apiAddContainer(containerInfoForm.value);
    if (response != null && response.data['message'] == 'success') {
      Get.back();
      if (arguments.value['refresh'] != null) {
        arguments.value['refresh']();
      }
      showCustomSnackbar(message: 'Successfully added.', status: '1');
    } else {
      showCustomSnackbar(
          message: 'Add failed, please try again later.', status: '3');
    }
  }

  updateContainer() async {
    if (containerInfoForm.value['isSeal'] == true) {
      containerInfoForm.value['status'] = 2;
      containerInfoForm.value['sealDate'] = getCurrentDate();
    }
    var response = await apiUpdateContainerById({
      ...containerInfoForm.value,
      "id": arguments.value['containerValue']['id']
    });
    if (response != null && response.data['message'] == 'success') {
      Get.back();
      if (arguments.value['refresh'] != null) {
        arguments.value['refresh']();
      }
      showCustomSnackbar(message: 'Successfully updated.', status: '1');
    } else {
      showCustomSnackbar(
          message: 'Update failed, please try again later.', status: '3');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    arguments.value = Get.arguments;
    isEdit.value = arguments.value['isEdit'];
    if (isEdit.value) {
      await setContainerInfo();
    }
    containerInfoForm.value["isSeal"] =
        (containerInfo.value.status == 2) ?? false;
    setFormList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
