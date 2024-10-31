import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/personal_center_controller.dart';
import '../../../services/screen_adapter.dart';
import '../../../widget/logo.dart';
import '../../../color/colors.dart';

class PersonalCenterView extends GetView<PersonalCenterController> {
  const PersonalCenterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My profile'),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(63),
              ScreenAdapter.height(20),
              ScreenAdapter.width(63),
              ScreenAdapter.height(20)),
          child: ListView(
            children: [
              // Text(
              //   "Personal info",
              //   style: TextStyle(
              //       fontSize: ScreenAdapter.fontSize(55),
              //       fontWeight: FontWeight.w500),
              // ),
              // Logo(),
              Column(
                children: [
                  InfoFileds(
                    filed: 'User name',
                    value: controller.userController.userInfo.value.username ??
                        "--",
                  ),
                  InfoFileds(
                    filed: 'Phone',
                    value:
                        controller.userController.userInfo.value.phone ?? "--",
                  ),
                  InfoFileds(
                    filed: 'Email',
                    value:
                        controller.userController.userInfo.value.email ?? "--",
                  ),
                  // InfoFileds(
                  //   filed: 'Role',
                  //   value: controller.userController.userInfo.value.roleName ??
                  //       "--",
                  // ),
                  // InfoFileds(
                  //   filed: 'User id',
                  //   value: controller.userController.userInfo.value.username ??
                  //       "--",
                  // ),
                  InfoFileds(
                    filed: 'Password',
                    value: "",
                    isDivider: false,
                    isUpdate: true,
                    isPass: true,
                    task: controller.passChange,
                    onOk: controller.updateInfo,
                  ),
                ],
              )
              // FilesMap(
              //     attribute: 'Username',
              //     value: controller.userController.userInfo.value.username ??
              //         '--'),
              // FilesMap(
              //     attribute: 'Phone',
              //     value:
              //         controller.userController.userInfo.value.phone ?? '--'),
              // FilesMap(
              //     attribute: 'Email',
              //     value:
              //         controller.userController.userInfo.value.email ?? '--'),
              // FilesMap(
              //     attribute: 'Role',
              //     value: controller.userController.userInfo.value.roleName ??
              //         '--'),
              // FilesMap(
              //     attribute: 'User id',
              //     value: controller.userController.userInfo.value.username ??
              //         '--'),
            ],
          )),
    );
  }
}

class FilesMap extends StatefulWidget {
  final String attribute;
  final String value;
  const FilesMap({Key? key, required this.attribute, required this.value})
      : super(key: key);

  @override
  State<FilesMap> createState() => _FilesMapState();
}

class _FilesMapState extends State<FilesMap> {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
          minHeight: 25,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.attribute,
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
            Divider()
          ],
        ));
  }
}

class InfoFileds extends StatefulWidget {
  bool flag = false;
  final String filed;
  final String value;
  final bool isDivider;
  final bool isUpdate;
  final void Function(String)? task;
  final Function? onOk;
  final bool isPass;
  InfoFileds(
      {super.key,
      required this.filed,
      required this.value,
      this.isUpdate = false,
      this.task,
      this.onOk,
      this.isPass = false,
      this.isDivider = true});
  @override
  State<InfoFileds> createState() => _InfoFiledsState();
}

class _InfoFiledsState extends State<InfoFileds> {
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
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            widget.isUpdate
                ? (!widget.flag
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            widget.flag = true;
                          });
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBlueColor,
                              height: 2),
                        ))
                    : InkWell(
                        onTap: () {
                          setState(() async {
                            var res = await widget.onOk!();
                            if (res == true) {
                              widget.flag = false;
                              // Get.offAllNamed("/pass_login");
                            }
                          });
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBlueColor,
                              height: 2),
                        )))
                : Text("")
          ],
        ),
        !widget.flag
            ? Text(
                widget.value,
                style: TextStyle(height: 2, fontFamily: "Roboto-Medium"),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: SizedBox(
                          height: 40,
                          child: TextField(
                            style: TextStyle(fontFamily: "Roboto-Medium"),
                            // focusNode: controller.focusNode,
                            decoration: InputDecoration(
                              // label: Text("${widget.value}"),
                              hintText: "${widget.value}",
                              // border: OutlineInputBorder(),
                            ),
                            obscureText: widget.isPass,
                            onChanged: widget.task,
                          ))),
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.flag = false;
                      });
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 189, 40, 119),
                          height: 2),
                    ),
                  ),
                ],
              ),
        widget.isDivider ? Divider(thickness: 1) : Text("")
      ],
    );
  }
}



// TextFormField(
//                           initialValue: widget.value,
//                           decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(vertical: 0),

//                             // 设置输入框内边距
//                             // 其他属性
//                           ),
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'Please enter';
//                             }
//                             return null;
//                           },
//                         ),