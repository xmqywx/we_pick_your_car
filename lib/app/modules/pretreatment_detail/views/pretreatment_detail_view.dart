import 'dart:ffi';
import 'dart:ui';

import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pretreatment_detail_controller.dart';
// import '../../../templete/details_templete.dart';
import '../../../widget/passButton.dart';
import '../../../widget/photo_upload.dart';
import '../../../widget/loading.dart';
import '../../../services/handle_status.dart';
import '../../../color/colors.dart';
import '../../../widget/license_plate.dart';
import '../../../widget/imgErrorBuild.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../../widget/image_preview_screen.dart';
import '../../../services/format_date.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widget/card_container.dart';
import '../../../widget/image_preview_screen.dart' as ImagePreviewScreenWidget;

class PretreatmentDetailView extends GetView<PretreatmentDetailController> {
  PretreatmentDetailView({Key? key}) : super(key: key);
  @override
  Widget _buildViewSignature() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 5,
          alignment: Alignment.centerLeft,
        ),
        Obx(() => (controller.signature.value == null ||
                controller.signature.value == "")
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
                                  controller.signature.value,
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
                          images: [controller.signature.value],
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

  Widget _StatusHandler() {
    print(controller.currentStatus);
    if (controller.currentStatus == 'Complete') {
      return PassButton(
        text: controller.orderDetail['invoice'] == null
            ? 'Send invoice'
            : 'Resend invoice',
        onPressed: controller.alertSendInvoiceDialog,
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
                    onPressed: controller.handleToConfirm,
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
                    onPressed: controller.handleToCancel,
                  ),
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PassButton(
                    text: "Complete current job",
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
                    onPressed: controller.handleToEdit,
                  ),
                )
              ],
            );
    }

    return Container();
  }

  bool hasError = false;
  Widget _buildBody() {
    return SingleChildScrollView(
        child: Column(
      children: [
        // Obx(() => AppBar(
        //       centerTitle: true,
        //       title: const Text("Job details"),
        //       elevation: 0,
        //       actions: <Widget>[
        //         if (controller.isLoadingController.isLoading.value)
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: CircularProgressIndicator(
        //               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //             ),
        //           ),
        //       ],
        //     )),
        Padding(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(32),
              ScreenAdapter.height(0), ScreenAdapter.width(32), 0),
          child: Column(
            children: [
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.height(30)),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                    "${handleFormatDateEEEEMMMMdyat(controller.arguments['schedulerStart'])}${handleFormathmma(controller.arguments['schedulerStart'])}-${handleFormathmma(controller.arguments['schedulerEnd'])}"),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              Obx(() => CardContainer(children: [
                        // Container(
                        //   height: ScreenAdapter.height(25.92),
                        //   color: handleStatusColor(
                        //       handleStatus(controller.arguments['status'])),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.fromLTRB(
                        //       ScreenAdapter.width(34.56),
                        //       ScreenAdapter.height(23.04),
                        //       ScreenAdapter.width(34.56),
                        //       ScreenAdapter.height(23.04)),
                        //   decoration: const BoxDecoration(
                        //       border: Border(
                        //           bottom: BorderSide(
                        //               color: AppColors.themeBorderColor1,
                        //               width: 1))),
                        // ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              ScreenAdapter.width(34.56),
                              ScreenAdapter.height(23.04),
                              ScreenAdapter.width(34.56),
                              ScreenAdapter.height(23.04)),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.themeBorderColor1,
                                      width: 1))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  // padding: EdgeInsets.all(20),
                                  child: Image.asset(
                                "assets/images/icon_location.png",
                                width: ScreenAdapter.width(48.96),
                              )),
                              SizedBox(
                                width: ScreenAdapter.width(15),
                              ),
                              Flexible(
                                flex: 1,
                                child: controller.arguments['pickupAddress'] !=
                                        ""
                                    ? InkWell(
                                        child: Text(
                                          controller.arguments['pickupAddress'],
                                          // overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          maxLines: 10,
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenAdapter.fontSize(50),
                                              fontFamily: "Roboto-Medium",
                                              color: AppColors.themeTextColor1),
                                        ),
                                        onTap: () async {
                                          final Uri url = Uri.parse(
                                              // 'https://maps.google.com/maps/search/?api=1&query=${controller.arguments['pickupAddress']}'
                                              'https://www.google.com/maps/dir/?api=1&destination=${controller.arguments['pickupAddress']}');
                                          // final url = Uri.parse(
                                          //     'https://www.google.com/maps/dir/?api=1&center=${controller.orderDetail['pickupAddressLat']},${controller.orderDetail['pickupAddressLng']}');
                                          // if (await canLaunchUrl(url)) {
                                          //   print(123123);
                                          //   await launchUrl(url);
                                          // } else {
                                          //   print(456456);
                                          //   throw 'Could not launch $url';
                                          // }

                                          if (!await launchUrl(
                                            url,
                                            mode:
                                                LaunchMode.externalApplication,
                                          )) {
                                            throw Exception(
                                                'Could not launch $url');
                                          }
                                        },
                                      )
                                    : Text("--"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(34.56),
                                ScreenAdapter.height(23.04),
                                ScreenAdapter.width(34.56),
                                ScreenAdapter.height(23.04)),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.themeBorderColor1,
                                        width: 1))),
                            child: Column(
                              children: [
                                FilesMap(
                                  attribute: '',
                                  value: '',
                                  valueWidget: Container(
                                    // height: ScreenAdapter.height(47),
                                    padding:
                                        EdgeInsets.all(ScreenAdapter.width(10)),
                                    // margin: EdgeInsets.only(
                                    //     bottom: ScreenAdapter.height(19)),
                                    decoration: BoxDecoration(
                                        color: handleStatusColor(handleStatus(
                                            controller.arguments['status'])),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenAdapter.height(12)))),
                                    child: Text(
                                      handleStatus(
                                          controller.arguments['status']),
                                      style: TextStyle(
                                          color: AppColors.themeTextColor1,
                                          fontSize:
                                              ScreenAdapter.fontSize(40.8),
                                          fontFamily: "Roboto-Medium",
                                          height: 1.3),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: ScreenAdapter.width(500),
                                    child: InkWell(
                                      child: Container(
                                          // width: ScreenAdapter.width(585),
                                          // height: ScreenAdapter.height(600),
                                          child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          // border: Border.all(
                                          //     color: Colors.grey,
                                          //     width: 2,
                                          //     style: BorderStyle.solid)
                                        ),
                                        child: controller
                                                    .orderDetail['image'] !=
                                                null
                                            ? Image.network(
                                                controller.orderDetail['image'],
                                                // fit: BoxFit.fitWidth,
                                                width: ScreenAdapter.width(585),
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  controller.hasError.value =
                                                      true;
                                                  return ImgErrorBuild();
                                                },
                                              )
                                            : Text(""),
                                      )),
                                      onTap: controller.orderDetail['image'] !=
                                              null
                                          ? () {
                                              if (!controller.hasError.value) {
                                                Get.to(ImagePreviewScreen(
                                                  images: [
                                                    controller.orderDetail[
                                                            'image'] ??
                                                        ""
                                                  ],
                                                  index: 0,
                                                ));
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(34.56),
                                ScreenAdapter.height(23.04),
                                ScreenAdapter.width(34.56),
                                ScreenAdapter.height(23.04)),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.themeBorderColor1,
                                        width: 1))),
                            child: Column(
                              children: [
                                // FilesMap(
                                //   attribute: '',
                                //   value:
                                //       "${controller.orderDetail['name'] ?? '--'}",
                                // ),
                                Text(
                                  "${controller.orderDetail['name'] ?? '--'}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: "Roboto-Medium",
                                    color: AppColors.themeTextColor1,
                                    fontSize: ScreenAdapter.fontSize(50),
                                    height: ScreenAdapter.height(80) /
                                        ScreenAdapter.fontSize(50),
                                  ),
                                ),
                                FilesMap(
                                    attribute: 'Reg. No.',
                                    value:
                                        "${controller.orderDetail['registrationNumber']}",
                                    valueWidget: LicensePlate(
                                      widget: Text(
                                          "${controller.orderDetail['registrationNumber']}"),
                                    )),
                                FilesMap(
                                  attribute: 'BODY',
                                  value: controller.orderDetail['bodyStyle'],
                                ),
                                FilesMap(
                                    attribute: 'VIN',
                                    value: controller.orderDetail['vinNumber']),
                                // FilesMap(
                                //   attribute: 'Engine',
                                //   value: controller.orderDetail['engine'],
                                //   flag: false,
                                // ),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdapter.width(34.56),
                                ScreenAdapter.height(23.04),
                                ScreenAdapter.width(34.56),
                                ScreenAdapter.height(23.04)),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.themeBorderColor1,
                                        width: 1))),
                            child: Column(
                              children: [
                                FilesMap(
                                  attribute: 'Customer',
                                  value: controller.orderDetail['firstName'],
                                ),
                                FilesMap(
                                  attribute: 'Email',
                                  value: controller.orderDetail['emailAddress'],
                                ),
                                Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 25,
                                    ),
                                    child: Column(
                                      children: [
                                        FilesMap(
                                          attribute: 'Phone',
                                          value:
                                              "${controller.orderDetail['registrationNumber']}",
                                          valueWidget: InkWell(
                                            onTap: () async {
                                              await FlutterPhoneDirectCaller
                                                  .callNumber(
                                                      controller.orderDetail[
                                                          'phoneNumber']);
                                            },
                                            child: Text(
                                              controller.orderDetail[
                                                      'phoneNumber'] ??
                                                  "----",
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontFamily: "Roboto-Medium",
                                                  color:
                                                      AppColors.themeTextColor1,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      AppColors.darkBlueColor),
                                            ),
                                          ),
                                        ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Flexible(
                                        //       child: Text(
                                        //         'Phone',
                                        //         textAlign: TextAlign.left,
                                        //         style: TextStyle(
                                        //             fontFamily: "Roboto-Medium",
                                        //             color: AppColors
                                        //                 .themeTextColor3),
                                        //       ),
                                        //     ),
                                        //     InkWell(
                                        //       onTap: () async {
                                        //         await FlutterPhoneDirectCaller
                                        //             .callNumber(
                                        //                 controller.orderDetail[
                                        //                     'phoneNumber']);
                                        //       },
                                        //       child: Text(
                                        //         controller.orderDetail[
                                        //                 'phoneNumber'] ??
                                        //             "----",
                                        //         textAlign: TextAlign.right,
                                        //         style: const TextStyle(
                                        //             fontFamily: "Roboto-Medium",
                                        //             color:
                                        //                 AppColors.themeTextColor1,
                                        //             decoration:
                                        //                 TextDecoration.underline,
                                        //             decorationColor:
                                        //                 AppColors.darkBlueColor),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // Divider(
                                        //     color: AppColors.black,
                                        //     height: ScreenAdapter.height(35),
                                        //     thickness: ScreenAdapter.height(3)),
                                      ],
                                    ))
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.fromLTRB(
                              ScreenAdapter.width(34.56),
                              ScreenAdapter.height(23.04),
                              ScreenAdapter.width(34.56),
                              ScreenAdapter.height(23.04)),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.themeBorderColor1,
                                      width: 1))),
                          child: Column(
                            children: [
                              // FilesMap(
                              //   attribute: 'Start time',
                              //   value: controller.arguments['schedulerStart'] !=
                              //           null
                              //       ? handleFormatDateDDMMYYYY(
                              //           controller.arguments['schedulerStart'])
                              //       : '--',
                              // ),
                              // FilesMap(
                              //   attribute: 'End time',
                              //   value:
                              //       controller.arguments['schedulerEnd'] != null
                              //           ? handleFormatDateDDMMYYYY(
                              //               controller.arguments['schedulerEnd'])
                              //           : '--',
                              //   // isUpdate: true,
                              // ),
                              // FilesMap(
                              //   attribute: 'Estimated price',
                              //   value: controller.orderDetail['recommendedPrice'],
                              //   prefix: '\$',
                              // ),
                              FilesMap(
                                attribute: 'Price',
                                value: controller.actualPayPrice.value,
                                flag: false,
                                isUpdate: controller.isEdit.value,
                                onChanged: controller.actualPayPriceChange,
                                prefix: '\$',
                              ),
                              FilesMap(
                                attribute: 'Model number',
                                value: controller.modelNumber.value,
                                flag: false,
                                isUpdate: controller.isEdit.value,
                                onChanged: controller.modelNumberChange,
                                // prefix: '\$',
                              ),
                              FilesMap(
                                attribute: 'Color',
                                value: controller.carColor.value,
                                flag: false,
                                isUpdate: controller.isEdit.value,
                                onChanged: controller.carColorChange,
                                // prefix: '\$',
                              ),
                              FilesMap(
                                  attribute: 'Payment method',
                                  value: controller.paymentMethod.value,
                                  flag: false,
                                  isUpdate: controller.isEdit.value,
                                  onSelectChanged:
                                      controller.paymentMethodChange,
                                  inputType: 'select',
                                  selectItems: [
                                    'Cheque',
                                    'Cash',
                                    'Direct Credit'
                                  ]
                                  // prefix: '\$',
                                  ),
                              // FilesMap(
                              //   attribute: 'Model number',
                              //   value: controller
                              //       .orderDetail['modelNumber'],
                              //   flag: false,
                              //   isUpdate: controller.isEdit.value,
                              //   // prefix: '\$',
                              // ),

                              FilesMap(
                                attribute: 'Site photos',
                                hasValue: false,
                              ),

                              ImagePickerWidget(
                                onImagesChanged: controller.changeImageFileDir,
                                images: controller.imageFileDir.value,
                                isEditable: controller.isEdit.value,
                              ),
                              // Text(controller.signature.value),
                              FilesMap(
                                attribute: 'Customer signature',
                                hasValue: false,
                              ),
                              _buildViewSignature(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(0),
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                              ScreenAdapter.width(34.56),
                              ScreenAdapter.height(15),
                              ScreenAdapter.width(34.56),
                              ScreenAdapter.height(51.84)),
                          decoration: const BoxDecoration(),
                          child: Obx(() => _StatusHandler()),
                        )
                      ])
                  // DetailTemplete(
                  //   customer_name: "${controller.orderDetail['firstName']}",
                  //   customer_phone_number:
                  //       "${controller.orderDetail['phoneNumber']}",
                  //   time_of_appointment:
                  //       "${controller.arguments['expectedDate']}",
                  //   start_postion:
                  //       "${controller.arguments['pickupAddress']}",
                  //   end_position: "${controller.arguments['end_position']}",
                  //   cost: "${controller.orderDetail['recommendedPrice']}",
                  //   status: "${controller.arguments['status']}",
                  //   whether_to_pay:
                  //       "${controller.arguments['whether_to_pay']}",
                  //   job_detail: controller.arguments,
                  //   arguments: controller.orderDetail,
                  // ),
                  ),
              const SizedBox(
                height: 10,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: (AppBar(
          centerTitle: true,
          title: const Text("Job details"),
          elevation: 0,
          actions: <Widget>[
            if (controller.isLoadingController.isLoading.value)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
          ],
        )),
        // body: Obx(() => !controller.isLoadingController.isLoading.value
        //     ? ()
        //     : Loading()));
        body: _buildBody());
  }
}

// class FilesMap extends StatelessWidget {
//   final String attribute;
//   final String value;
//   final bool flag;
//   final Widget? keyWidget;
//   final Widget? valueWidget;

//   FilesMap({
//     Key? key,
//     required this.attribute,
//     required this.value,
//     this.flag = true,
//     this.keyWidget,
//     this.valueWidget,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Widget keyText = Text(
//       attribute,
//       textAlign: TextAlign.left,
//       style: TextStyle(
//           fontFamily: "Roboto-Medium",
//           color: AppColors.themeTextColor3,
//           fontSize: ScreenAdapter.fontSize(40.32)),
//     );
//     Widget valueText = Text(
//       value,
//       textAlign: TextAlign.right,
//       style: TextStyle(
//           fontFamily: "Roboto-Medium",
//           color: AppColors.themeTextColor1,
//           fontSize: ScreenAdapter.fontSize(40.32)),
//     );

//     if (keyWidget != null) {
//       keyText = keyWidget!;
//     }

//     if (valueWidget != null) {
//       valueText = valueWidget!;
//     }

//     return Container(
//         constraints: const BoxConstraints(
//           minHeight: 25,
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(child: keyText),
//               Flexible(child: valueText),
//             ],
//           ),
//         ));
//   }
// }

class FilesMap extends StatelessWidget {
  final String attribute;
  final String? value;
  final bool flag;
  final Widget? keyWidget;
  final Widget? valueWidget;
  final bool isUpdate;
  final Function(String)? onChanged;
  final String prefix;
  final bool hasValue;
  final String inputType;
  final void Function(String?)? onSelectChanged;
  final List<String> selectItems;
  FilesMap(
      {Key? key,
      required this.attribute,
      this.value,
      this.flag = true,
      this.keyWidget,
      this.valueWidget,
      this.isUpdate = false,
      this.hasValue = true,
      this.onChanged,
      this.onSelectChanged,
      this.inputType = 'input',
      this.selectItems = const [],
      this.prefix = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = ScreenAdapter.fontSize(50);
    final double lineHeight = ScreenAdapter.height(80.0);

    Widget keyText = Text(
      attribute,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: "Roboto-Medium",
        color: AppColors.themeTextColor3,
        fontSize: fontSize,
        height: lineHeight / fontSize,
      ),
    );
    Widget valueText;
    if (isUpdate) {
      TextEditingController controller = TextEditingController(text: value);
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
      final FocusNode focusNode = FocusNode();
      if (inputType == 'select') {
        // String selectValue = selectItems[0];
        // print("select------------------------------");
        // print(selectItems.contains(value));
        // print("select------------------------------");
        // if (selectItems.contains(value)) {
        //   selectValue = "${value}";
        // }
        valueText = DropdownButton<String>(
          value: selectItems.contains(value) ? value : selectItems[0],
          underline: Text(""),
          isDense: true,
          style: TextStyle(
              fontFamily: "Roboto-Medium", color: AppColors.themeTextColor1),
          items: selectItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onSelectChanged,
        );
      } else {
        valueText = Container(
          width: _calculateTextFieldWidth(),
          // height: ScreenAdapter.height(60),
          child: TextField(
            controller: controller,
            scrollPadding: EdgeInsets.zero,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.themeTextColor1, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.themeTextColor1, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                isDense: true,
                // filled: true,
                // 设置背景色
                fillColor: AppColors.lightBlueColor),
            style: TextStyle(
              fontSize: fontSize,
              height: lineHeight / fontSize,
              fontFamily: "Roboto-Medium",
            ),
            onChanged: onChanged,
            textAlign: TextAlign.center,
          ),
        );
      }
    } else {
      valueText = Text(
        value != null ? (prefix + (value ?? "")) : "----",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: "Roboto-Medium",
          color: AppColors.themeTextColor1,
          fontSize: fontSize,
          height: lineHeight / fontSize,
        ),
      );
    }

    if (keyWidget != null) {
      keyText = keyWidget!;
    }

    if (valueWidget != null) {
      valueText = valueWidget!;
    }

    return Container(
      margin: EdgeInsets.only(top: 2),
      constraints: const BoxConstraints(
        minHeight: 25,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flexible(child: keyText),
            keyText,
            hasValue ? Flexible(child: valueText) : const Text(""),
          ],
        ),
      ),
    );
  }

  double _calculateTextFieldWidth() {
    // final double fontSize = ScreenAdapter.fontSize(40.32);
    // final double paddingWidth = ScreenAdapter.width(16.0);

    // final TextPainter textPainter = TextPainter(
    //   text: TextSpan(
    //     text: value,
    //     style: TextStyle(
    //       fontSize: fontSize,
    //       height: ScreenAdapter.height(60.0) / fontSize,
    //     ),
    //   ),
    //   textDirection: TextDirection.ltr,
    // )..layout();

    // return textPainter.width + paddingWidth;
    return ScreenAdapter.width(400);
  }
}
