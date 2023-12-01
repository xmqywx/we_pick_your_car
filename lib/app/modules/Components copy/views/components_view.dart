import 'package:car_wrecker/app/templete/no_data_templete.dart';
import 'package:flutter/material.dart';
import '../../../const/wrecker.dart';
import 'package:get/get.dart';
import 'package:scan/scan.dart';
import '../controllers/components_controller.dart';
import '../../../color/colors.dart';
import '../../../services/screen_adapter.dart';
import '../../../text/paragraph.dart';
import '../templete/container_info.dart';

class ComponentsView extends GetView<ComponentsController> {
  const ComponentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: MyParagraph(
            text: controller.containerNumber.value,
            fontSize: 65,
          ),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.qr_code_scanner),
          //     onPressed: () {
          //       Get.toNamed("/container-detail", arguments: {"isEdit": false});
          //     },
          //   ),
          // ],
        ),
        floatingActionButton: Visibility(
          visible: containerStatus[controller.arguments.value['containerValue']
                  ['status']]?['op']
              .contains('add'),
          child: FloatingActionButton(
            onPressed: controller.containerAdd,
            child: Icon(Icons.qr_code_scanner),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                  onRefresh: controller.handleRefresh,
                  child: ListView(
                    controller: controller.listScrollController,
                    padding: EdgeInsets.fromLTRB(0, ScreenAdapter.height(12), 0,
                        ScreenAdapter.height(24)),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenAdapter.height(15),
                            horizontal: ScreenAdapter.width(15)),
                        child: MyParagraph(
                          text: "Container info",
                          fontSize: 55,
                        ),
                      ),
                      ContainerInfo(
                          edit: controller.containerEdit,
                          add: controller.containerAdd,
                          delete: controller.alertDeleteContainerDialog,
                          info: controller.arguments.value['containerValue']),
                      if (controller.componentList.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenAdapter.height(15),
                              horizontal: ScreenAdapter.width(15)),
                          child: MyParagraph(
                            text: "Components",
                            fontSize: 55,
                          ),
                        ),
                      ...controller.initListView(),
                      if (controller.componentList.isNotEmpty &&
                          !controller.canLoadMore.value)
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: MyParagraph(
                            text: "Can't load more.",
                            align: TextAlign.center,
                            fontSize: 40,
                          ),
                        ),
                      if (controller.componentList.isEmpty)
                        EmptyStatus(title: "No Component"),
                      // Container(
                      //   width: 250, // 自定义包裹大小
                      //   height: 250,
                      //   child: ScanView(
                      //     controller: controller.scanController,
                      //     scanAreaScale: 0.7, // 自定义扫描区域的比例
                      //     scanLineColor: Colors.green.shade400, // 自定义扫描线的颜色
                      //     onCapture: (data) {
                      //       // 扫描结果的回调函数
                      //     },
                      //   ),
                      // ),
                    ],
                  )),
            )
          ],
        )));
  }
}
