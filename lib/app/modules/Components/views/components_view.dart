import 'package:car_wrecker/app/templete/no_data_templete.dart';
import 'package:flutter/material.dart';
import '../../../const/wrecker.dart';
import 'package:get/get.dart';
import '../controllers/components_controller.dart';
import '../../../color/colors.dart';
import '../../../services/screen_adapter.dart';
import '../../../text/paragraph.dart';
import 'package:car_wrecker/app/widget/card_container.dart';

class ComponentsView extends GetView<ComponentsController> {
  const ComponentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: MyParagraph(
            text: controller.containerNumber.value ?? 'Container',
            fontSize: 65,
          ),
          centerTitle: true,
          actions: [
            if (controller.isExist.value)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: controller.containerEdit,
              ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: containerStatus[controller.arguments.value['containerValue']
                      ?['status']]?['op'] !=
                  null &&
              containerStatus[controller.arguments.value['containerValue']
                      ?['status']]?['op']
                  .contains('add') &&
              controller.isExist.value,
          child: FloatingActionButton(
            onPressed: controller.containerAdd,
            // onPressed: controller.scanQRCode,
            child: const Icon(Icons.qr_code_scanner),
          ),
        ),
        body: Column(children: [
          Expanded(
            flex: 1,
            child: RefreshIndicator(
                onRefresh: controller.handleRefresh,
                child: ListView(
                  // controller: controller.listScrollController,
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdapter.height(12), 0, ScreenAdapter.height(24)),
                  children: controller.isExist.value
                      ? [
                          ...controller.initListView(),
                          if (controller.componentList.isNotEmpty &&
                              !controller.canLoadMore.value)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: MyParagraph(
                                text: "Can't load more.",
                                align: TextAlign.center,
                                fontSize: 40,
                              ),
                            ),
                          if (controller.componentList.isEmpty)
                            EmptyStatus(title: "No Component"),
                        ]
                      : [
                          MyCardContainer(
                              crossAlign: CrossAxisAlignment.center,
                              padding: EdgeInsets.all(ScreenAdapter.width(20)),
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenAdapter.width(20),
                                      bottom: ScreenAdapter.width(20)),
                                  child: MyParagraph(
                                    text:
                                        "You currently have no unsealed containers. Would you like to add one?",
                                    fontSize: 55,
                                    align: TextAlign.center,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.add,
                                    size: ScreenAdapter.width(30),
                                  ),
                                  label: Text(
                                    "Add Container",
                                    style: TextStyle(
                                      fontSize: ScreenAdapter.width(30),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ScreenAdapter.width(20)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: ScreenAdapter.width(20),
                                      horizontal: ScreenAdapter.width(40),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.toNamed("/container-detail",
                                        arguments: {
                                          "isEdit": false,
                                          "refresh": controller.handleRefresh
                                        });
                                  },
                                ),
                                SizedBox(
                                  height: ScreenAdapter.width(20),
                                )
                              ])
                        ],
                )),
          )
        ])));
  }
}
