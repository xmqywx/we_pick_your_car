import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/component_detail_controller.dart';
import '../../../text/paragraph.dart';

import '../../../services/screen_adapter.dart';
import '../../../color/colors.dart';
import '../../../widget/card_container.dart';
import '../../../widget/custom_form.dart';
import '../../../widget/passButton.dart';

class ComponentDetailView extends GetView<ComponentDetailController> {
  const ComponentDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: MyParagraph(
              text: controller.wreckedData.value.disassemblyNumber ?? '----',
              fontSize: 65,
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Column(
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
                              ScreenAdapter.width(35),
                            ),
                            children: [
                              DynamicForm(
                                formKey: controller.formKey,
                                formFields: controller.formList.value,
                                formData: controller.wreckedDataForm.value,
                                formDataChange: controller.formDataChange,
                              ),
                            ],
                          ),
                          // Other content...
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenAdapter.width(160),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white, // Optional: Add a background color
                  padding: EdgeInsets.all(ScreenAdapter.width(15)),
                  child: Column(
                    children: [
                      if (!controller.isAddToContainer.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (controller.containerStatus >= 0 &&
                                controller.containerStatus != 2)
                              Expanded(
                                flex: 2,
                                child: PassButton(
                                  isLoading: controller.isLoading.value,
                                  onPressed: controller
                                      .handleDeleteComponentFromThisContainer,
                                  btnColor: AppColors.redColor,
                                  text: 'Remove',
                                ),
                              ),
                            if (controller.containerStatus >= 0 &&
                                controller.containerStatus != 2)
                              SizedBox(
                                width: ScreenAdapter.width(20),
                              ),
                            Expanded(
                              flex: 2,
                              child: PassButton(
                                isLoading: controller.isLoading.value,
                                onPressed: controller.formSubmit,
                                btnColor: AppColors.logoBgc,
                                text: 'Update',
                              ),
                            ),
                          ],
                        ),
                      if (controller.isAddToContainer.value)
                        PassButton(
                          isLoading: controller.isLoading.value,
                          onPressed: controller.canAddToContainer.value
                              ? controller.handleToAddContainer
                              : controller.tip,
                          btnColor: AppColors.logoBgc,
                          disabled: !controller.canAddToContainer.value,
                          text: 'Add',
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
