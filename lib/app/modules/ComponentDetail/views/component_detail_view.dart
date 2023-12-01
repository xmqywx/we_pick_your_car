import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/component_detail_controller.dart';
import '../../../text/paragraph.dart';

import '../../../services/screen_adapter.dart';
import '../../../color/colors.dart';
import '../../../widget/photo_upload.dart';
import '../../../widget/card_container.dart';
import '../../../templete/no_data_templete.dart';
import '../../../widget/custom_form.dart';
import '../../../widget/passButton.dart';

class ComponentDetailView extends GetView<ComponentDetailController> {
  const ComponentDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: MyParagraph(
              text: controller.wreckedData.value.disassemblyNumber ?? '----',
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
                                  formData: controller.wreckedDataForm.value,
                                  formDataChange: controller.formDataChange,
                                ),
                              ]),
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!controller.isAddToContainer.value)
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (controller.containerStatus >= 0 &&
                                          controller.containerStatus != 2)
                                        Expanded(
                                            flex: 3,
                                            child: PassButton(
                                              onPressed: controller
                                                  .handleDeleteComponentFromThisContainer,
                                              btnColor: AppColors.redColor,
                                              text: 'Remove from container',
                                            )),
                                      if (controller.containerStatus >= 0 &&
                                          controller.containerStatus != 2)
                                        SizedBox(
                                          width: ScreenAdapter.width(20),
                                        ),
                                      Expanded(
                                        flex: 2,
                                        child: PassButton(
                                          onPressed: controller.formSubmit,
                                          btnColor: AppColors.logoBgc,
                                          text: 'Update',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (controller.isAddToContainer.value)
                                PassButton(
                                  onPressed: controller.canAddToContainer.value
                                      ? controller.handleToAddContainer
                                      : controller.tip,
                                  btnColor: AppColors.logoBgc,
                                  disabled: !controller.canAddToContainer.value,
                                  text:
                                      'Add to ${controller.argContainerNumber}',
                                ),
                            ],
                          )
                        ])),
              )
            ],
          ),
        ));
  }
}
