import 'dart:io';

import 'package:car_wrecker/app/color/colors.dart';
import 'package:car_wrecker/app/text/paragraph.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:ui';
import '../../../widget/image_preview_screen.dart';
import '../../../widget/imgErrorBuild.dart';
import '../controllers/job_details_controller.dart';
import '../../../widget/custom_form.dart';
import '../../../services/keep_alive_wrapper.dart';
import '../../../services/screen_adapter.dart';
import '../../../widget/card_container.dart';
import '../templates/JobFormContainer.dart';
import '../../../widget/image_preview_screen.dart' as ImagePreviewScreenWidget;
import '../../../services/format_date.dart';
import '../../../widget/passButton.dart';
import '../templates/jobAgreenmentView.dart';

class JobDetailsView extends GetView<JobDetailsController> {
  const JobDetailsView({Key? key}) : super(key: key);
  Widget _StatusHandler() {
    print(controller.currentStatus);
    if (controller.currentStatus == 'Complete') {
      return PassButton(
        text: controller.orderInfo.value.invoice == null
            ? 'Send invoice'
            : 'Resend invoice',
        onPressed: controller.sendInvoice,
        btnColor: AppColors.logoBgc,
      );
    }
    if (controller.currentStatus == 'Waiting') {
      return controller.isEdit.value
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: PassButton(
                    text: "Confirm",
                    btnColor: AppColors.logoBgc,
                    onPressed: controller.toUpdateJobForm,
                  ),
                ),
                SizedBox(
                  width: ScreenAdapter.width(20),
                ),
                Expanded(
                  flex: 1,
                  child: PassButton(
                    text: "Cancel",
                    btnColor: AppColors.white,
                    textColor: AppColors.themeTextColor1,
                    onPressed: controller.toCancel,
                  ),
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: PassButton(
                    text: "Complete",
                    btnColor: AppColors.logoBgc,
                    onPressed: controller.alertEndDialog,
                  ),
                ),
                SizedBox(
                  width: ScreenAdapter.width(20),
                ),
                Expanded(
                  flex: 1,
                  child: PassButton(
                    text: "Edit",
                    btnColor: AppColors.white,
                    textColor: AppColors.themeTextColor1,
                    onPressed: controller.toChangeEdit,
                  ),
                )
              ],
            );
    }

    return Container();
  }

  Widget _buildViewSignature() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 5,
          alignment: Alignment.centerLeft,
        ),
        Obx(() => (controller.orderInfoForm.value['signature'] == null ||
                controller.orderInfoForm.value['signature'] == "")
            ? InkWell(
                onTap: controller.openBottomSheet,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: ScreenAdapter.width(250),
                    height: ScreenAdapter.width(250),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: ScreenAdapter.width(2),
                            color: AppColors.themeBorderColor1),
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.width(20))),
                    child: Center(
                        child: Image.asset(
                      "assets/images/icon_sign.png",
                      width: ScreenAdapter.width(70),
                    ))),
              )
            : GestureDetector(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Container(
                        height: ScreenAdapter.width(250),
                        width: ScreenAdapter.width(250),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: ScreenAdapter.width(2),
                                color: AppColors.themeBorderColor1),
                            borderRadius:
                                BorderRadius.circular(ScreenAdapter.width(20)),
                            image: DecorationImage(
                                image: NetworkImage(
                                  controller.orderInfoForm.value['signature'],
                                ),
                                fit: BoxFit.cover)),
                        // child: Image.network(controller.signature.value),
                      ),
                      onTap: () {
                        // Get.to(ImagePreviewScreenWidget.ImagePreviewScreen(
                        //   images: [controller.signature.value],
                        //   index: 0,
                        // ));

                        Get.to(ImagePreviewScreenWidget.ImagePreviewScreen(
                          images: [controller.orderInfoForm.value['signature']],
                          index: 0,
                        ));
                      },
                    ),
                    controller.isEdit.value
                        ? Container(
                            child: TextButton(
                              onPressed: controller.openBottomSheet,
                              child: Text('Change'),
                            ),
                          )
                        : Text(""),
                  ],
                ),
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(ScreenAdapter.width(130)),
            child: AppBar(
              elevation: 0,
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                MyParagraph(
                  text: controller.orderInfo.value.quoteNumber ?? 'Job details',
                  fontSize: 65,
                ),
                if (controller.currentStatus == 'Complete')
                  Container(
                    // height: ScreenAdapter.height(47),
                    padding: EdgeInsets.all(ScreenAdapter.width(10)),
                    margin: EdgeInsets.only(left: ScreenAdapter.height(19)),
                    decoration: BoxDecoration(
                        color: Color(0xffC5D4FF),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenAdapter.height(12)))),
                    child: MyParagraph(
                      text: 'completed',
                      color: AppColors.themeTextColor1,
                      fontSize: 29,
                    ),
                  )
              ]),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.transparent,
                    ),
                    onPressed: null),
              ],
            )),
        body: Column(
          children: [
            DefaultTabController(
                length: 6,
                child: Expanded(
                    flex: 1,
                    child: Scaffold(
                      appBar: PreferredSize(
                          preferredSize: Size.fromHeight(50),
                          child: AppBar(
                            automaticallyImplyLeading: false, // 隐藏返回按钮
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            title: Container(
                              height: 45,
                              margin: EdgeInsets.zero,
                              child: TabBar(
                                // indicatorSize: TabBarIndicatorSize.label,
                                controller: controller.tabController,
                                labelPadding: EdgeInsets.symmetric(vertical: 0),
                                indicatorPadding: EdgeInsets.zero,
                                indicatorColor: AppColors.black,
                                tabs: const [
                                  Tab(
                                    icon: Icon(Icons.schedule),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.car_crash),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.question_answer),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.attachment_outlined),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.person),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.payment_sharp),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      body: TabBarView(
                        controller: controller.tabController,
                        children: [
                          JobFormContainer(
                              handleRefresh: controller.handleRefresh,
                              contents: [
                                CardContainer(children: [
                                  CardTitle(title: 'Schedule'),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenAdapter.width(35),
                                          0,
                                          ScreenAdapter.width(35),
                                          ScreenAdapter.width(35)),
                                      child: Column(
                                        children: [
                                          DynamicForm(
                                            formKey: controller.scheduleFormKey,
                                            formFields: controller
                                                .scheduleFormList.value,
                                            formData:
                                                controller.orderInfoForm.value,
                                            formDataChange:
                                                controller.orderFormDataChange,
                                          ),
                                        ],
                                      )),
                                ])
                              ]),
                          JobFormContainer(
                              handleRefresh: controller.handleRefresh,
                              contents: [
                                CardContainer(children: [
                                  CardTitle(title: 'Car'),
                                  controller.carInfo.value.image != null &&
                                          controller.carInfo.value.image != ''
                                      ? Container(
                                          width: ScreenAdapter.width(500),
                                          child: InkWell(
                                            child: Container(
                                                child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                              child: controller.carInfo.value
                                                          .image !=
                                                      null
                                                  ? Image.network(
                                                      controller.carInfo.value
                                                              .image ??
                                                          '',
                                                      // fit: BoxFit.fitWidth,
                                                      width:
                                                          ScreenAdapter.width(
                                                              585),
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        controller.hasError
                                                            .value = true;
                                                        return const ImgErrorBuild();
                                                      },
                                                    )
                                                  : const SizedBox.shrink(),
                                            )),
                                            onTap: controller
                                                        .carInfo.value.image !=
                                                    null
                                                ? () {
                                                    if (!controller
                                                        .hasError.value) {
                                                      Get.to(ImagePreviewScreen(
                                                        images: [
                                                          controller
                                                                  .carInfo
                                                                  .value
                                                                  .image ??
                                                              ""
                                                        ],
                                                        index: 0,
                                                      ));
                                                    }
                                                  }
                                                : null,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenAdapter.width(35),
                                        0,
                                        ScreenAdapter.width(35),
                                        ScreenAdapter.width(35)),
                                    child: Builder(builder: (context) {
                                      return DynamicForm(
                                          formKey: controller.carFormKey,
                                          formFields:
                                              controller.carFormList.value,
                                          formData:
                                              controller.carInfoForm.value,
                                          formDataChange:
                                              controller.carFormDataChange);
                                    }),
                                  )
                                ])
                              ]),
                          JobFormContainer(
                              handleRefresh: controller.handleRefresh,
                              contents: [
                                CardContainer(children: [
                                  CardTitle(title: 'Info'),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenAdapter.width(35),
                                        0,
                                        ScreenAdapter.width(35),
                                        ScreenAdapter.width(35)),
                                    child: DynamicForm(
                                      formKey: controller.questionnaireFormKey,
                                      formFields: controller
                                          .questionnaireFormList.value,
                                      formData: controller.orderInfoForm.value,
                                      formDataChange:
                                          controller.orderFormDataChange,
                                    ),
                                  )
                                ])
                              ]),
                          JobFormContainer(
                              handleRefresh: controller.handleRefresh,
                              contents: [
                                CardContainer(children: [
                                  CardTitle(title: 'Attachments'),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenAdapter.width(35),
                                          0,
                                          ScreenAdapter.width(35),
                                          ScreenAdapter.width(35)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DynamicForm(
                                            formKey:
                                                controller.attachmentsFormKey,
                                            formFields: controller
                                                .attachmentsFormList.value,
                                            formData:
                                                controller.orderInfoForm.value,
                                            formDataChange:
                                                controller.orderFormDataChange,
                                          ),
                                          SizedBox(
                                            height: ScreenAdapter.width(15),
                                          ),
                                          JobAgreenmentView(),
                                          MyParagraph(
                                            text: "Signature",
                                            fontSize: 45,
                                            color: AppColors.themeTextColor1,
                                            align: TextAlign.left,
                                          ),
                                          _buildViewSignature()
                                        ],
                                      )),
                                ])
                              ]),
                          JobFormContainer(
                              handleRefresh: controller.handleRefresh,
                              contents: [
                                CardContainer(children: [
                                  CardTitle(title: 'Customer'),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenAdapter.width(35),
                                        0,
                                        ScreenAdapter.width(35),
                                        ScreenAdapter.width(35)),
                                    child: Builder(builder: (context) {
                                      // print(controller.customerFormList.value,);
                                      // print(controller.customerInfoForm.value,);
                                      return DynamicForm(
                                        formKey: controller.customerFormKey,
                                        formFields:
                                            controller.customerFormList.value,
                                        formData:
                                            controller.customerInfoForm.value,
                                        formDataChange:
                                            controller.customerFormDataChange,
                                      );
                                    }),
                                  ),
                                ]),
                                if (controller.isEdit.value)
                                  InkWell(
                                    child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            top: ScreenAdapter.width(35),
                                            bottom: ScreenAdapter.width(35),
                                            right: ScreenAdapter.width(35)),
                                        child: MyParagraph(
                                          text: controller
                                                  .isAddSecondaryPerson.value
                                              ? 'Close Secondary Person'
                                              : 'Add Secondary Person',
                                          color: AppColors.themeTextColor4,
                                          align: TextAlign.right,
                                        )),
                                    onTap:
                                        controller.toChangeIsAddSecondaryPerson,
                                  ),
                                if (controller.isAddSecondaryPerson.value)
                                  CardContainer(children: [
                                    CardTitle(
                                        title:
                                            'Sec. Phone & Person for Car Meet'),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenAdapter.width(35),
                                          0,
                                          ScreenAdapter.width(35),
                                          ScreenAdapter.width(35)),
                                      child: Builder(builder: (context) {
                                        // print(controller
                                        //     .secondaryPersonFormList.value);
                                        // print(controller
                                        //     .secondaryPersonInfoForm.value);
                                        return DynamicForm(
                                          formKey:
                                              controller.secondaryPersonFormKey,
                                          formFields: controller
                                              .secondaryPersonFormList.value,
                                          formData: controller
                                              .secondaryPersonInfoForm.value,
                                          formDataChange: controller
                                              .secondaryPersonFormDataChange,
                                        );
                                      }),
                                    )
                                  ])
                              ]),
                          JobFormContainer(
                              handleRefresh: controller.handleRefresh,
                              contents: [
                                CardContainer(children: [
                                  CardTitle(title: 'Payment'),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenAdapter.width(35),
                                        0,
                                        ScreenAdapter.width(35),
                                        ScreenAdapter.width(35)),
                                    child: Builder(builder: (context) {
                                      return Obx(() {
                                        //print('------------------------------>${controller.isBankDetailShow.value}');
                                        return DynamicForm(
                                          formKey: controller.paymentFormKey,
                                          formFields:
                                              controller.paymentFormList.value,
                                          formData:
                                              controller.orderInfoForm.value,
                                          formDataChange:
                                              controller.orderFormDataChange,
                                        );
                                      });
                                      return DynamicForm(
                                        formKey: controller.paymentFormKey,
                                        formFields:
                                            controller.paymentFormList.value,
                                        formData:
                                            controller.orderInfoForm.value,
                                        formDataChange:
                                            controller.orderFormDataChange,
                                      );
                                    }),
                                  )
                                ])
                              ]),
                        ],
                      ),
                    ))),
            if (!Platform.isIOS)
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: controller.isKeyboardOpen.value
                    ? ScreenAdapter.height(700)
                    : 0,
              ),
            ClipRect(
              child: Container(
                // color: AppColors.accent,
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(34.56),
                    ScreenAdapter.height(15),
                    ScreenAdapter.width(34.56),
                    ScreenAdapter.height(51.84)),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppColors.themeTextColor4, width: 2))),
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Obx(() => _StatusHandler())),
              ),
            )
          ],
        )));
  }
}
