import 'dart:ffi';

import 'package:get/get.dart';
import '../../../api/wrecker.dart';
import 'package:flutter/material.dart';
import '../../../models/component_model.dart';
import '../../../widget/toast.dart';
import '../../../text/paragraph.dart';

class ComponentDetailController extends GetxController {
  //TODO: Implement ComponentDetailController
  var arguments = {}.obs;
  RxString barcodeTxt = "".obs;
  var wreckedData = Component().obs;
  RxList<Map<String, dynamic>> formList = RxList<Map<String, dynamic>>([]);
  RxMap<String, dynamic> wreckedDataForm = RxMap<String, dynamic>({});
  RxBool isAddToContainer = false.obs;
  RxBool canAddToContainer = false.obs;
  int containerStatus = -1.obs;
  RxString argContainerNumber = ''.obs;
  final formKey = GlobalKey<FormState>();
  RxBool fieldsDisabled = false.obs;
  setFormList() {
    formList.value = [
      {
        "label": "Number",
        "prop": "disassemblyNumber",
        "disabled": true,
        "value": wreckedData.value.disassemblyNumber ?? '',
        "component": {
          "type": "input",
          "placeholder": "Please input the number.",
        },
        "rules": [
          {
            "pattern": r'^[a-zA-Z]+$',
            "errorMessage": "Name should contain only alphabets",
          },
        ],
      },
      {
        "label": "Container NO.",
        "prop": "containerNumber",
        "disabled": true,
        "value": wreckedData.value.containerNumber ?? '----',
        "component": {
          "type": "input",
          "placeholder": "Please input the category.",
        },
        "rules": [
          {
            "pattern": r'^[a-zA-Z]+$',
            "errorMessage": "Name should contain only alphabets",
          },
        ],
      },
      {
        "label": "Category",
        "prop": "disassemblyCategory",
        "disabled": true,
        "value": wreckedData.value.disassemblyCategory ?? '',
        "component": {
          "type": "input",
          "placeholder": "Please input the category.",
        },
        "rules": [
          {
            "pattern": r'^[a-zA-Z]+$',
            "errorMessage": "Name should contain only alphabets",
          },
        ],
      },
      {
        "label": "Info",
        "value": wreckedData.value.disassmblingInformation ?? '[]',
        "prop": "disassmblingInformation",
        "disabled": true,
        "component": {
          "type": wreckedData.value.disassemblyCategory == 'Catalytic Converter'
              ? "uploadImage"
              : "input",
          "placeholder": "Please input the part info.",
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
        "label": "Description",
        "prop": "disassemblyDescription",
        "value": wreckedData.value.disassemblyDescription ?? '',
        "disabled": isAddToContainer.value,
        "component": {
          "type": "input",
          "placeholder": "Please input the part description.",
        },
        "rules": [
          {
            "pattern": r'^[a-zA-Z]+$',
            "errorMessage": "Name should contain only alphabets",
          },
        ],
      },
      {
        "label": "Part Images",
        "prop": "disassemblyImages",
        "disabled": isAddToContainer.value,
        "value": wreckedData.value.disassemblyImages ?? '[]',
        "component": {
          "type": "uploadImage",
        },
        "rules": [],
      }
    ];
    formList.refresh();
  }

  @override
  void onInit() async {
    super.onInit();
    arguments.value = Get.arguments;
    setComponentDetail();
  }

  getComponentDetail(partId) async {
    var response = await apiGetComponentInfo(partId: partId);
    if (response != null && response.data['message'] == 'success') {
      return response.data['data'];
    } else {
      return {};
    }
  }

  setComponentDetail() async {
    if (arguments.value['componentId'] != null) {
      var response = await getComponentDetail(arguments.value['componentId']);
      wreckedData.value = Component.fromJson(response);
      containerStatus = wreckedData.value.containerStatus ?? -1;
      print("containerStatus, ${containerStatus}");
      wreckedDataForm.value = {
        "id": wreckedData.value.id,
        "disassemblyDescription": wreckedData.value.disassemblyDescription,
        "disassemblyImages": wreckedData.value.disassemblyImages,
        "containerNumber": wreckedData.value.containerNumber
      };
      if (arguments.value['addToContainer'] != null &&
          arguments.value['addToContainer']) {
        isAddToContainer.value = true;
      } else {
        isAddToContainer.value = false;
      }
      canAddToContainer.value = wreckedData.value.containerNumber == null;
      argContainerNumber.value = arguments.value['containerNumber'] ?? '';
      if (isAddToContainer.value && !canAddToContainer.value) {
        tip();
      }
      setFormList();
    }
  }

  tip() {
    showCustomSnackbar(
        message:
            'The component is in container ${wreckedData.value.containerNumber}.',
        status: '3');
  }

  final Rx<TextEditingController> textEditingController =
      TextEditingController().obs;
  Future<void> handleRefresh() async {
    setComponentDetail();
  }

  onSearchChange(value) {
    barcodeTxt.value = value;
  }

  formDataChange(key, value) {
    wreckedDataForm.value[key] = value;
    wreckedDataForm.refresh();
  }

  formSubmit() async {
    if (formKey.currentState!.validate()) {
      // 表单验证通过，执行提交逻辑
      // onSubmit(formValues);
      updatePart(data: wreckedDataForm.value);
    }
  }

  handleToAddContainer() async {
    var updateData = {
      "id": wreckedDataForm.value['id'],
      "containerNumber": argContainerNumber.value
    };
    await updatePart(data: updateData, op: 'add_to_container', isNext: false);
    isEdit.value = true;
    arguments.value['addToContainer'] = false;
    setComponentDetail();
  }

  handleDeleteComponentFromThisContainer() async {
    var result = await Get.dialog(
        AlertDialog(
          title: MyParagraph(
            text: "Remove from container!",
            fontSize: 65,
          ),
          content: MyParagraph(
              text:
                  "Are you sure you want to remove this part from the container?"),
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
      var updateData = {
        "partId": wreckedDataForm.value['id'],
        "containerNumber": wreckedData.value.containerNumber
      };
      updatePart(data: updateData, op: 'delete_from_this_container');
    }
  }

  updatePart(
      {required Map data, String op = 'update', bool isNext = true}) async {
    final response;
    if (op == 'add_to_container') {
      response = await apiAddToComponent(data);
    } else if (op == 'delete_from_this_container') {
      response = await apiDeleteComponentFromThisContainer(data);
    } else {
      response = await apiUpdateComponent(data);
    }

    if (response != null && response.data['message'] == 'success') {
      if (isNext) {
        Get.back();
      }
      if (arguments.value['refresh'] != null) {
        arguments.value['refresh']();
      }
      showCustomSnackbar(message: 'Successfully updated.', status: '1');
    } else {
      showCustomSnackbar(
          message: 'Update failed, please try again later.', status: '3');
    }
    return response;
  }

  RxBool isEdit = false.obs;
  RxList<String> imageFileDir = <String>[].obs;
}
