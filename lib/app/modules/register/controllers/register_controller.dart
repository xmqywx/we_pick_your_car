import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/user.dart';
import 'dart:async';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import '../../../widget/toast.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> formList = RxList<Map<String, dynamic>>([]);
  RxMap<String, dynamic> formData = RxMap<String, dynamic>({});
  RxBool isLoading = false.obs;
  RxBool isRegistered = false.obs;
// 使用 RxList<Map<String, dynamic>> 来存储角色和部门选项
  RxList<Map<String, dynamic>> roleOptions = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> departmentOptions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    setFormList();
    await fetchRoleAndDepartment();
    setFormList();
  }

  Future<void> fetchRoleAndDepartment() async {
    try {
      isLoading.value = true;
      final response = await apiGetRoleDepartmentList();
      isLoading.value = false;
      if (response.data['code'] == 1000) {
        print(response);
        // 处理角色列表
        var resData = response.data['data'];
        roleOptions.value = (resData['roleList'] as List)
            .map((role) => {
                  "label": role['name'],
                  "value": role['id'].toString(),
                })
            .cast<Map<String, dynamic>>()
            .toList();

        // 处理部门列表
        departmentOptions.value = (resData['departmentList'] as List)
            .where((department) => department['id'] != 1) // 过滤掉 id 为 1 的部门
            .map((department) => {
                  "label": department['name'],
                  "value": department['id'].toString(),
                })
            .cast<Map<String, dynamic>>()
            .toList();
        print(roleOptions.value[0]['value']);
        formData.value['roleIdList'] = roleOptions.value[0]['value'];
        formData.value['departmentId'] = departmentOptions.value[0]['value'];
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  RxMap<String, dynamic> formFieldJudge = {
    "username": {
      "judge": false,
      "message": "The container number has already been used."
    },
    "password": {
      "judge": false,
      "message": "Password format requires 6 or more characters."
    }
  }.obs;
  final fieldPasswordKey = GlobalKey<FormFieldState>();
  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  void setFormList() {
    print('begin');
    formList.value = [
      {
        "label": "User name",
        "prop": "username",
        "component": {
          "type": "input",
          "placeholder": "Please input user name.",
        },
        "rules": [
          {"require": true, "message": "User name cannot be empty."},
          {
            "pattern": r'^[a-zA-Z0-9]+$',
            "errorMessage":
                "Username should contain only alphanumeric characters",
          },
        ],
      },
      {
        "label": "Password",
        "prop": "password",
        "component": {
          "type": "password",
          "placeholder": "Please input password.",
        },
        "fieldKey": fieldPasswordKey,
        "rules": [
          {"require": true, "message": "User name cannot be empty."},
        ],
        "triggeredOnChange": (data) {
          debouncer(() async {
            if (data == '' || data == null) {
              return;
            }
            formFieldJudge.value['password']['judge'] =
                !RegExp(r'^.{6,}$').hasMatch(formData['password']);
            setFormList();
            fieldPasswordKey.currentState?.validate();
          });
          setFormList();
        }
      },
      {
        "label": "Role",
        "prop": "roleIdList",
        "value":
            roleOptions.value.isNotEmpty ? roleOptions.value[0]['value'] : null,
        "component": {
          "type": "select",
          "options": roleOptions,
          "placeholder": "Please select the role.",
        },
        "rules": [
          {"require": true, "message": "Role cannot be empty."}
        ],
      },
      {
        "label": "Department",
        "prop": "departmentId",
        "value": departmentOptions.value.isNotEmpty
            ? departmentOptions.value[0]['value']
            : null,
        "component": {
          "type": "select",
          "options": departmentOptions,
          "placeholder": "Please select the department.",
        },
        "rules": [
          {"require": true, "message": "Department cannot be empty."}
        ],
      },
      {
        "label": "Phone",
        "prop": "phone",
        "component": {
          "type": "input",
          "placeholder": "Please input phone number.",
        },
        "rules": [
          {
            "pattern": r'^\d{10}$',
            "errorMessage": "Phone number must be 10 digits",
          },
        ],
      },
      {
        "label": "Email",
        "prop": "email",
        "component": {
          "type": "input",
          "placeholder": "Please input email.",
        },
        "rules": [
          {
            "pattern": r'^[^@]+@[^@]+\.[^@]+',
            "errorMessage": "Invalid email format",
          },
        ],
      },
    ];
    formList.refresh();
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Prepare data for registration
      var data = {
        "username": formData['username'],
        "password": formData['password'],
        "roleIdList": [formData['roleIdList']],
        "departmentId": formData['departmentId'].toString(),
        "phone": formData['phone'],
        "email": formData['email'],
        "status": 1, // Assuming active status
      };

      // Call your API for registration
      final response = await apiReg(data);

      isLoading.value = false;

      if (response != null && response.data['message'] == 'success') {
        isRegistered.value = true;
        showCustomSnackbar(
            status: '1', message: "Registration successful, please log in.");
        Get.offNamed("/pass_login"); // Navigate to login page
      } else {
        // Handle error
        showCustomSnackbar(
            status: '3',
            message: "Registration failed, ${response.data['message']}");
      }
    }
  }
}
