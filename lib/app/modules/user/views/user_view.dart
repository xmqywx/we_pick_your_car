import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../services/screen_adapter.dart';
import '../controllers/user_controller.dart';
import '../../../widget/passButton.dart';
import '../../../widget/logo.dart';
import '../../../color/colors.dart';

class UserView extends GetView<UserController> {
  const UserView({Key? key}) : super(key: key);
  Widget _UserInfo() {
    return Stack(
      children: [
        ListView(
          children: [
            Container(
              height: ScreenAdapter.height(400),
              decoration: const BoxDecoration(
                color: AppColors.logoBgc,
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   width: ScreenAdapter.width(55),
                  // ),
                  Container(
                      height: ScreenAdapter.height(450),
                      width: ScreenAdapter.width(500),
                      margin: EdgeInsets.only(
                          left: ScreenAdapter.width(40),
                          right: ScreenAdapter.width(40)),
                      child: Logo(
                        logoWidth: 550,
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${controller.userInfo.value.email ?? '- -'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: ScreenAdapter.height(20),
                          ),
                          Text(
                            "${controller.userInfo.value.username}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(
              height: ScreenAdapter.height(20),
            ),
            ListTile(
              onTap: () {
                Get.toNamed('/personal-center');
              },
              title: Text(
                "My profile",
                style: TextStyle(),
              ),
              leading: CircleAvatar(child: Icon(Icons.people)),
            ),
            const Divider(),
            // const ListTile(
            //   title: Text("System settings"),
            //   leading: CircleAvatar(child: Icon(Icons.settings)),
            // )
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: PassButton(
                onPressed: () {
                  controller.loginOut();
                },
                text: "Log out",
                btnColor: AppColors.logoBgc,
              ),
            ))
      ],
    );
  }

  Widget _NoLogin() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.only(left: ScreenAdapter.width(40)),
          height: ScreenAdapter.height(400),
          decoration: const BoxDecoration(
            color: AppColors.darkBlueColor,
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You haven't signed in yet",
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: ScreenAdapter.height(20),
                      ),
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // 将按钮背景色改为白色
                            onPrimary: AppColors
                                .darkBlueColor, // 将文字颜色改为Color.fromRGBO(240, 115, 49, 1)
                            elevation: 0, // 将阴影去掉
                          ),
                          child: Text("Click to login"),
                          onPressed: () {
                            Get.toNamed("/pass_login");
                          },
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        SizedBox(
          height: ScreenAdapter.height(20),
        ),
        const ListTile(
          title: Text("System settings"),
          leading: CircleAvatar(child: Icon(Icons.settings)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        backgroundColor: Colors.white,
        body: Obx(() => controller.isLogin.value ? _UserInfo() : _NoLogin()));
  }
}
