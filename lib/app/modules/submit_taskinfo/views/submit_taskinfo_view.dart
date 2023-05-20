import 'package:car_wrecker/app/widget/card_container.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/submit_taskinfo_controller.dart';
import '../../../widget/photo_upload.dart';
import '../../../services/screen_adapter.dart';
import '../../../widget/passButton.dart';
import '../../../widget/image_preview_screen.dart' as ImagePreviewScreenWidget;
import '../../../color/colors.dart';

class SubmitTaskinfoView extends GetView<SubmitTaskinfoController> {
  const SubmitTaskinfoView({Key? key}) : super(key: key);

  Widget _buildViewSignature() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: Text(
            "Customer signature",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto-Medium"),
          ),
        ),
        Obx(() => (controller.signature.value == null ||
                controller.signature.value == "")
            ? InkWell(
                child: Container(
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
                onTap: controller.openBottomSheet,
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
                    Container(
                      child: TextButton(
                        onPressed: controller.openBottomSheet,
                        child: Text('Change'),
                      ),
                    ),
                  ],
                ),
              ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Job info'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(32),
              ScreenAdapter.height(20), ScreenAdapter.width(32), 0),
          child: ListView(
            children: [
              CardContainer(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(34.56),
                      ScreenAdapter.height(23.04),
                      ScreenAdapter.width(34.56),
                      ScreenAdapter.height(23.04)),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.themeBorderColor1, width: 1))),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Vehicle information",
                          style: TextStyle(
                              color: AppColors.themeTextColor1,
                              fontSize: ScreenAdapter.fontSize(40.32),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto-Medium"),
                        ),
                      ),
                      // const Divider(),
                      TextInput(
                        fields: "Model number",
                        placeholder: "Model number",
                        onChanged: controller.modelNumberChange,
                      ),
                      TextInput(
                        fields: "Color",
                        placeholder: "Color",
                        onChanged: controller.carColorChange,
                      ),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              "Payment method",
                              style: TextStyle(
                                fontFamily: 'Roboto-Medium',
                                color: Color(0xff9BA4BD),
                              ),
                            ),
                            DropdownButton<String>(
                              value: controller.paymentMethod.value,
                              items: <String>['Cheque', 'Cash', 'Direct Credit']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: controller.paymentMethodChange,
                            )
                          ],
                        ),
                      ),
                      TextInput(
                        fields: "Actual price",
                        placeholder: "Actual price",
                        onChanged: controller.actualPayPriceChange,
                      ),
                      // ImagePickerWidget(
                      //   onImagesChanged: controller.changeImageFileDir,
                      // ),
                      // Text(controller.signature.value),
                      _buildViewSignature(),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenAdapter.width(34.56),
                        ScreenAdapter.height(0),
                        ScreenAdapter.width(34.56),
                        ScreenAdapter.height(40.04)),
                    child: PassButton(
                      text: "Submit",
                      onPressed: () {
                        controller.updateJobInfo();
                      },
                    )),
              ])
            ],
          ),
        ));
  }
}

class TextInput extends StatelessWidget {
  final void Function(String)? onChanged;
  final String fields;
  final String placeholder;
  const TextInput(
      {super.key,
      required this.onChanged,
      required this.fields,
      required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: ScreenAdapter.height(150),
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(8),
      //     border: Border.all(color: const Color(0xFFE5E6E6), width: 2)),
      child: TextField(
        // focusNode: controller.focusNode,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: ScreenAdapter.fontSize(48),
          fontFamily: "Roboto-Medium",
        ),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: ScreenAdapter.width(40.32)),
          label: Text(fields),
          labelStyle: TextStyle(
            color: Color(0xff9BA4BD),
            // fontStyle: FontStyle.italic,
          ),
          hintText: placeholder,
          // hintStyle: TextStyle(
          //   color: Color(0xffF1ECEF),
          //   fontStyle: FontStyle.italic,
          // ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.themeBorderColor1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.themeBorderColor1),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.themeBorderColor1),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
