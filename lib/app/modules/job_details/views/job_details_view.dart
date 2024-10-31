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
        isLoading: controller.isLoading.value,
        isBorder: true,
        btnBorderCorlor: AppColors.logoBgc,
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
                    isLoading: controller.isLoading.value,
                    text: "Confirm",
                    isBorder: true,
                    btnBorderCorlor: AppColors.logoBgc,
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
                    isLoading: controller.isLoading.value,
                    text: "Cancel",
                    isBorder: true,
                    btnBorderCorlor: AppColors.white,
                    btnColor: AppColors.white,
                    textColor: AppColors.themeTextColor1,
                    onPressed: controller.toCancel,
                  ),
                )
              ],
            )
          : Row(
              children: [
                // Expanded(
                //   flex: 1,
                //   child: PassButton(
                //     isLoading: controller.isLoading.value,
                //     text: "Complete",
                //     isBorder: true,
                //     btnBorderCorlor: AppColors.logoBgc,
                //     btnColor: AppColors.logoBgc,
                //     onPressed: controller.alertEndDialog,
                //   ),
                // ),
                // SizedBox(
                //   width: ScreenAdapter.width(20),
                // ),
                // Expanded(
                //   flex: 1,
                //   child: PassButton(
                //     isLoading: controller.isLoading.value,
                //     text: "Edit",
                //     isBorder: true,
                //     btnBorderCorlor: AppColors.white,
                //     btnColor: AppColors.white,
                //     textColor: AppColors.themeTextColor1,
                //     onPressed: controller.toChangeEdit,
                //   ),
                // )
              ],
            );
    }

    return Container();
  }

  Widget _buildViewSignature() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Obx(() => (controller.orderInfoForm.value['signature'] == null ||
                controller.orderInfoForm.value['signature'].isEmpty)
            ? InkWell(
                onTap: controller.openBottomSheet,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: ScreenAdapter.width(300),
                  height: ScreenAdapter.width(300),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: ScreenAdapter.width(2),
                      color: AppColors.themeBorderColor1,
                    ),
                    borderRadius:
                        BorderRadius.circular(ScreenAdapter.width(20)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,
                          size: ScreenAdapter.width(50),
                          color: AppColors.themeTextColor1),
                      SizedBox(height: ScreenAdapter.width(10)),
                      Text(
                        'Add Signature',
                        style: TextStyle(
                          color: AppColors.themeTextColor1,
                          fontSize: ScreenAdapter.fontSize(16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Get.to(ImagePreviewScreenWidget.ImagePreviewScreen(
                    images: [controller.orderInfoForm.value['signature']],
                    index: 0,
                  ));
                },
                child: Container(
                  height: ScreenAdapter.width(300),
                  width: ScreenAdapter.width(300),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: ScreenAdapter.width(2),
                      color: AppColors.themeBorderColor1,
                    ),
                    borderRadius:
                        BorderRadius.circular(ScreenAdapter.width(20)),
                    image: DecorationImage(
                      image: NetworkImage(
                          controller.orderInfoForm.value['signature']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.bottomRight,
                  child: controller.isEdit.value
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: controller.openBottomSheet,
                            child: Container(
                              padding: EdgeInsets.all(
                                  15), // Increased padding for a larger touch area
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.85), // Slightly transparent for aesthetics
                                borderRadius: BorderRadius.circular(
                                    25), // More rounded corners for the button
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons
                                    .edit, // Changed to an icon for a more intuitive button
                                color: AppColors.themeTextColor1,
                                size: ScreenAdapter.fontSize(
                                    60), // Adjusted icon size for better visibility
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        // resizeToAvoidBottomInset: true,
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
              actions: const [
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.transparent,
                    ),
                    onPressed: null),
              ],
            )),
        floatingActionButton: Visibility(
          visible: !controller.isEdit.value &&
              controller.currentStatus.value == 'Waiting',
          child: FloatingActionButton(
            onPressed: controller.toChangeEdit,
            child: Icon(
              Icons.edit,
            ),
          ),
        ),
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
                                          ScreenAdapter.width(35),
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
                                        ScreenAdapter.width(35),
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
                                        ScreenAdapter.width(35),
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
                                          ScreenAdapter.width(35),
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
                                          Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: MyParagraph(
                                                text: "Signature",
                                                // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjusted vertical padding
                                                color: Colors
                                                    .grey, // Adjusted label color
                                                // fontSize: 16,
                                                fontFamily: 'Roboto-Medium'),
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
                                        ScreenAdapter.width(35),
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
                                          ScreenAdapter.width(35),
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
                                        ScreenAdapter.width(35),
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
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: controller.isKeyboardOpen.value
                  ? ScreenAdapter.height(700)
                  : 0,
            ),
            // if (!Platform.isIOS)
            if (!(controller.currentStatus == 'Waiting' &&
                !controller.isEdit.value))
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
