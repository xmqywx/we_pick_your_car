import 'package:car_wrecker/app/widget/passButton.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/container_detail_controller.dart';
import '../../../text/paragraph.dart';
import '../../../services/screen_adapter.dart';
import '../../../widget/card_container.dart';
import '../../../widget/custom_form.dart';
import '../../../templete/empty.dart';
import '../../../color/colors.dart';

class ContainerDetailView extends GetView<ContainerDetailController> {
  const ContainerDetailView({Key? key}) : super(key: key);

  Widget _WidgetContainerForm() {
    return CardContainer(children: []);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: MyParagraph(
              text: controller.isEdit.value
                  ? (controller.containerInfo.value.containerNumber ?? '----')
                  : "Add",
              fontSize: 65,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: RefreshIndicator(
                    onRefresh: controller.handleRefresh,
                    child: ListView(
                        // controller: controller.listScrollController,
                        padding: EdgeInsets.all(ScreenAdapter.width(15)),
                        children: [
                          CardContainer(
                              crossAlign: CrossAxisAlignment.start,
                              padding: EdgeInsets.fromLTRB(
                                  ScreenAdapter.width(20),
                                  ScreenAdapter.width(10),
                                  ScreenAdapter.width(20),
                                  ScreenAdapter.width(35)),
                              children: [
                                DynamicForm(
                                  formKey: controller.formKey,
                                  formFields: controller.formList.value,
                                  formData: controller.containerInfoForm.value,
                                  formDataChange: controller.formDataChange,
                                ),
                              ]),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (controller.isEdit.value &&
                                  controller.containerInfo.value.status == 0)
                                Expanded(
                                    flex: 1,
                                    child: PassButton(
                                      onPressed:
                                          controller.alertDeleteContainerDialog,
                                      btnColor: AppColors.redColor,
                                      text: 'Delete',
                                    )),
                              if (controller.isEdit.value &&
                                  controller.containerInfo.value.status == 0)
                                SizedBox(
                                  width: ScreenAdapter.width(20),
                                ),
                              Expanded(
                                  flex: 1,
                                  child: PassButton(
                                    onPressed: controller.formSubmit,
                                    btnColor: AppColors.logoBgc,
                                    text: 'Submit',
                                  ))
                            ],
                          )
                        ])),
              )
            ],
          ),
        ));
  }
}
