import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/personal_center_controller.dart';
import '../../../services/screen_adapter.dart';
import '../../../color/colors.dart';

class PersonalCenterView extends GetView<PersonalCenterController> {
  const PersonalCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(20),
          ScreenAdapter.height(20),
          ScreenAdapter.width(20),
          ScreenAdapter.height(20),
        ),
        child: ListView(
          children: [
            // 个人信息标题
            Text(
              "Personal Info",
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(24),
                fontWeight: FontWeight.bold,
                color: Colors.black87, // 使用深色文本
              ),
            ),
            SizedBox(height: ScreenAdapter.height(20)), // 间距

            // 信息字段
            Card(
              elevation: 4, // 阴影效果
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 圆角
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 内边距
                child: Column(
                  children: [
                    InfoFields(
                      filed: 'User Name',
                      value:
                          controller.userController.userInfo.value.username ??
                              "--",
                    ),
                    InfoFields(
                      filed: 'Phone',
                      value: controller.userController.userInfo.value.phone ??
                          "--",
                    ),
                    InfoFields(
                      filed: 'Email',
                      value: controller.userController.userInfo.value.email ??
                          "--",
                    ),
                    InfoFields(
                      filed: 'Password',
                      value: "",
                      isDivider: false,
                      isUpdate: true,
                      isPass: true,
                      task: controller.passChange,
                      onOk: controller.updateInfo,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenAdapter.height(20)), // 间距

// 注销账户按钮
            Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(20)), // 上边距
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // 靠右对齐
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20), // 按钮内边距
                      elevation: 5, // 阴影效果
                      backgroundColor: AppColors.darkRedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 圆角
                      ),
                    ),
                    child: Text(
                      "Delete account request", // 更新按钮标签为英文
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(38), // 调整字体大小
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 按钮文字颜色
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 弹出注销确认对话框
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure to send the request?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // 关闭对话框
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.deleteAccount();
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
}

class InfoFields extends StatefulWidget {
  final String filed;
  final String value;
  final bool isDivider;
  final bool isUpdate;
  final void Function(String)? task;
  final Function? onOk;
  final bool isPass;

  const InfoFields({
    Key? key,
    required this.filed,
    required this.value,
    this.isUpdate = false,
    this.task,
    this.onOk,
    this.isPass = false,
    this.isDivider = true,
  }) : super(key: key);

  @override
  State<InfoFields> createState() => _InfoFieldsState();
}

class _InfoFieldsState extends State<InfoFields> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.filed,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            widget.isUpdate
                ? (!flag
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            flag = true;
                          });
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBlueColor,
                              height: 2),
                        ))
                    : InkWell(
                        onTap: () async {
                          var res = await widget.onOk!();
                          if (res == true) {
                            setState(() {
                              flag = false;
                            });
                          }
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBlueColor,
                              height: 2),
                        )))
                : const Text("")
          ],
        ),
        !flag
            ? Text(
                widget.value,
                style: const TextStyle(height: 2, fontFamily: "Roboto-Medium"),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontFamily: "Roboto-Medium"),
                      decoration: InputDecoration(
                        hintText: widget.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      obscureText: widget.isPass,
                      onChanged: widget.task,
                    ),
                  ),
                  const SizedBox(width: 10), // 间距
                  InkWell(
                    onTap: () {
                      setState(() {
                        flag = false;
                      });
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 189, 40, 119),
                          height: 2),
                    ),
                  ),
                ],
              ),
        widget.isDivider ? const Divider(thickness: 1) : const SizedBox.shrink(),
      ],
    );
  }
}
