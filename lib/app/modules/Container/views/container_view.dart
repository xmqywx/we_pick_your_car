import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/container_controller.dart';
import '../../../color/colors.dart';
import '../../../services/screen_adapter.dart';
import '../../../text/paragraph.dart';
import '../../../templete/no_data_templete.dart';

class ContainerView extends GetView<ContainerController> {
  const ContainerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: MyParagraph(
            text: 'Container',
            fontSize: 65,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                Get.toNamed("/container-detail", arguments: {
                  "isEdit": false,
                  "refresh": controller.handleRefresh
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                  onRefresh: controller.handleRefresh,
                  child: Obx(() => ListView(
                      controller: controller.listScrollController,
                      padding: EdgeInsets.fromLTRB(0, ScreenAdapter.height(12),
                          0, ScreenAdapter.height(24)),
                      children: controller.containerList.value.isNotEmpty
                          ? [
                              Column(children: controller.initListView()),
                              !controller.canLoadMore.value
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(top: 5, bottom: 5),
                                      child: MyParagraph(
                                        text: "Can't load more.",
                                        align: TextAlign.center,
                                        fontSize: 40,
                                      ),
                                    )
                                  : const SizedBox()
                            ]
                          : [EmptyStatus(title: "No data")]))),
            )
          ],
        ));
  }
}
