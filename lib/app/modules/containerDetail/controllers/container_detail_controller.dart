import 'package:car_wrecker/app/widget/toast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import '../../../api/wrecker.dart';
import '../../../models/container_model.dart';
import 'package:flutter/material.dart';
import '../../../services/format_date.dart';
import '../../../services/storage.dart';
import 'dart:async';

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

  RxBool isLoading = false.obs;

  Future getContainerInfo() async {
    isLoading.value = true;
    var response =
        await apiGetContainerInfo(id: arguments.value['containerValue']['id']);
    isLoading.value = false;
    print(response);
    if (response != null && response.data['message'] == 'success') {
      return response.data['data'];
    } else {
      return {};
    }
  }

  Future handleApi(data) async {
    isLoading.value = true;
    var response = await data['api'](data['payload']);
    isLoading.value = false;
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
      "photo": containerInfo.value.photo,
      "departmentId": containerInfo.value.departmentId,
    };

    containerInfo.refresh();
  }

  final fieldContainerNumberKey = GlobalKey<FormFieldState>();
  final fieldSealedNumberKey = GlobalKey<FormFieldState>();
  RxBool validating = false.obs;
  RxMap<String, dynamic> formFieldJudge = {
    "containerNumber": {
      "judge": false,
      "message": "The container number has already been used."
    },
    "sealNumber": {
      "judge": false,
      "message": "The seal number has already been used."
    }
  }.obs;
  final debouncer = Debouncer(delay: Duration(milliseconds: 500));
  final debouncer2 = Debouncer(delay: Duration(milliseconds: 500));
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
        "fieldKey": fieldContainerNumberKey,
        "rules": [
          {
            "require": true,
            "message": "Container number cannot be empty.",
          },
          // if (!isEdit.value)
          //   {
          //     "judge": formFieldJudge.value['containerNumber'],
          //     "message": "The container number has already been used.",
          //   },
          // if (!isEdit.value)
          //   {
          //     "validator": (containerNumber) async {
          //       var res = await handleApi({
          //         "api": checkIsUniqueContainerNumber,
          //         "payload": {"containerNumber": containerNumber}
          //       });
          //       if (res != null) {
          //         if (res['isUnique']) {
          //           // formFieldJudge.value['containerNumber'] = res['isUnique'];
          //           return null;
          //         } else {
          //           return "The container number has already been used.";
          //         }
          //       } else {
          //         return "Unable to verify!";
          //       }
          //     },
          //     "message": "The container number has already been used.",
          //   },
        ],
        "triggeredOnChange": (data) {
          debouncer(() async {
            if (data == '' || data == null) {
              return;
            }
            formFieldJudge.value['containerNumber']['judge'] =
                !await validatorIsUnique(payload: {
              "containerNumber": containerInfoForm.value['containerNumber']
            }, api: checkIsUniqueContainerNumber);
            setFormList();
            fieldContainerNumberKey.currentState?.validate();
          });
          setFormList();
        }
      },
      {
        "label": "Commence date",
        "prop": "startDeliverTime",
        "value": containerInfo.value.startDeliverTime ?? '',
        "component": {
          "type": "datepicker",
          "placeholder": "Please select the commence date.",
        },
        "rules": [
          {
            "require": true,
            "message": "Commence date cannot be empty.",
          },
        ],
      },
      {
        "label": "Empty container photos",
        "prop": "photo",
        "value": containerInfo.value.photo ?? '[]',
        "component": {
          "type": "uploadImage",
        },
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
        // "hidden": !containerInfoForm.value['isSeal'],
        "component": {
          "type": "input",
          "trigger": "change",
          "placeholder": "Please input the container number.",
        },
        "fieldKey": fieldSealedNumberKey,
        "rules": [
          {
            "require": containerInfoForm.value['isSeal'],
            "message": "Seal number cannot be empty when sealed.",
          },
          // if (!isEdit.value)
          //   {
          //     "judge": formFieldJudge.value['sealNumber'],
          //     "message": "The seal number has already been used.",
          //   },
        ],
        "triggeredOnChange": (data) {
          debouncer2(() async {
            if (data == '' || data == null) {
              return;
            }
            formFieldJudge.value['sealNumber']['judge'] =
                !await validatorIsUnique(
                    payload: {"sealNumber": data, "id": containerInfo.value.id},
                    api: checkIsUniqueSealedNumber);

            setFormList();
            fieldSealedNumberKey.currentState?.validate();
          });
        }
      }
    ];
    formList.refresh();
    print("set form list, ${formList.value[0]}");
  }

  validatorIsUnique({required Map payload, required api}) async {
    var res = await handleApi({"api": api, "payload": payload});
    if (res != null) {
      return res['isUnique'];
    } else {
      return false;
    }
  }

  Future<void> handleRefresh() async {
    if (isEdit.value) {
      await setContainerInfo();
    }
    containerInfoForm.value["isSeal"] =
        (containerInfo.value.status == 2) ?? false;
  }

  formSubmit() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      if (isEdit.value) {
        print(containerInfoForm.value['isSeal']);
        if (containerInfoForm.value['isSeal'] == true) {
          var result = await Get.dialog(
              AlertDialog(
                title: const Text("Prompt information!"),
                content:
                    const Text("Are you sure you want to seal this container?"),
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
            updateContainer();
          } else {}
        } else {
          updateContainer();
        }
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
    if (containerInfoForm.value['departmentId'] == null) {
      final userinfo = await Storage.getData('userinfo');

      containerInfoForm.value['departmentId'] = userinfo['departmentId'];
      containerInfoForm.value['createBy'] = userinfo['id'];
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
    isLoading.value = true;
    var response = await apiUpdateContainerById({
      ...containerInfoForm.value,
      "id": arguments.value['containerValue']['id']
    });
    isLoading.value = false;
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
