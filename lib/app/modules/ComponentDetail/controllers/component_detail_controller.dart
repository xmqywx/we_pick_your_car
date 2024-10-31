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
  final descriptionKey = GlobalKey();

  RxBool isLoading = false.obs;

  setFormList() {
    formList.value = [
      {
        "label": "Number #",
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
      // {
      //   "label": "Category",
      //   "prop": "disassemblyCategory",
      //   "disabled": true,
      //   "value": wreckedData.value.disassemblyCategory ?? '',
      //   "component": {
      //     "type": "input",
      //     "placeholder": "Please input the category.",
      //   },
      //   "rules": [
      //     {
      //       "pattern": r'^[a-zA-Z]+$',
      //       "errorMessage": "Name should contain only alphabets",
      //     },
      //   ],
      // },
      // {
      //   "label": "Catalytic Converter Name",
      //   "prop": "catalyticConverterName",
      //   "hidden":
      //       wreckedData.value.disassemblyCategory != 'Catalytic Converter',
      //   "disabled": true,
      //   "value": wreckedData.value.catalyticConverterName ?? '',
      //   "component": {
      //     "type": "input",
      //     "placeholder": "Please input the Catalytic Converter Name.",
      //   },
      //   "rules": [],
      // },
      // {
      //   "label": "Catalytic Converter Number",
      //   "prop": "catalyticConverterNumber",
      //   "hidden":
      //       wreckedData.value.disassemblyCategory != 'Catalytic Converter',
      //   "disabled": true,
      //   "value": wreckedData.value.catalyticConverterNumber ?? '',
      //   "component": {
      //     "type": "input",
      //     "placeholder": "",
      //   },
      //   "rules": [],
      // },
      {
        "label": "Info",
        "value": wreckedData.value.disassmblingInformation ?? '[]',
        "prop": "disassmblingInformation",
        "disabled": true,
        "component": {
          "type": "input",
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
        "fieldKey": descriptionKey,
        "component": {
          "type": "input",
          "placeholder": "Please input the part description.",
        },
        "rules": [],
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
      },
      {
        "label": "REGO",
        "value": wreckedData.value.registrationNumber ?? '',
        "prop": "registrationNumber",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "VIN",
        "value": wreckedData.value.vin ?? '',
        "prop": "vin",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Year",
        "value": wreckedData.value.year ?? '',
        "prop": "year",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Make",
        "value": wreckedData.value.make ?? '',
        "prop": "make",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Model",
        "value": wreckedData.value.model ?? '',
        "prop": "model",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Series",
        "value": wreckedData.value.series ?? '',
        "prop": "series",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Fuel Type",
        "value": wreckedData.value.fuel ?? '',
        "prop": "fuel",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Transmission",
        "value": wreckedData.value.transmission ?? '',
        "prop": "transmission",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Cylinders",
        "value": wreckedData.value.cylinders ?? '',
        "prop": "cylinders",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Engine Number",
        "value": wreckedData.value.engineNumber ?? '',
        "prop": "engineNumber",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
      {
        "label": "Engine Code",
        "value": wreckedData.value.engineCode ?? '',
        "prop": "engineCode",
        "disabled": true,
        "component": {
          "type": "input",
          "placeholder": "----",
        },
        "triggeredOnChange": (data) {
          setFormList();
        },
        "rules": [],
      },
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
    isLoading.value = true;
    var response = await apiGetComponentInfo(partId: partId);
    isLoading.value = false;
    if (response != null && response.data['message'] == 'success') {
      return response.data['data'];
    } else {
      return {};
    }
  }

  setComponentDetail() async {
    if (arguments.value['componentId'] != null) {
      isLoading.value = true;
      var response = await getComponentDetail(arguments.value['componentId']);
      isLoading.value = false;
      wreckedData.value = Component.fromJson(response);
      containerStatus = wreckedData.value.containerStatus ?? -1;
      print("containerStatus, ${containerStatus}");
      wreckedDataForm.value = {
        "id": wreckedData.value.id,
        "disassemblyDescription": wreckedData.value.disassemblyDescription,
        "disassemblyImages": wreckedData.value.disassemblyImages,
        "containerNumber": wreckedData.value.containerNumber,
        "disassmblingInformation": wreckedData.value.disassmblingInformation,
        // "catalyticConverterName": wreckedData.value.catalyticConverterName,
        // "catalyticConverterNumber": wreckedData.value.catalyticConverterNumber,
      };
      if (arguments.value['addToContainer'] != null &&
          arguments.value['addToContainer']) {
        isAddToContainer.value = true;
      } else {
        isAddToContainer.value = false;
      }
      canAddToContainer.value = wreckedData.value.containerNumber == null ||
          wreckedData.value.containerNumber == '';
      argContainerNumber.value = arguments.value['containerNumber'] ?? '';
      if (isAddToContainer.value) {
        if (!canAddToContainer.value) {
          tip();
        }
        // else if (wreckedData.value.disassemblyCategory ==
        //     'Catalytic Converter') {
        //   tipCC();
        // }
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

  tipCC() {
    showCustomSnackbar(
        message: 'Unable to add Catalytic Converter to container.',
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
    isLoading.value = true;
    if (op == 'add_to_container') {
      response = await apiAddToComponent(data);
    } else if (op == 'delete_from_this_container') {
      response = await apiDeleteComponentFromThisContainer(data);
    } else {
      response = await apiUpdateComponent(data);
    }

    isLoading.value = false;

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
