import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wrecking_controller.dart';
import '../../../services/screen_adapter.dart';
import '../../../color/colors.dart';
import '../../../widget/photo_upload.dart';
import '../../../widget/card_container.dart';
import '../../../templete/no_data_templete.dart';
import '../../../text/paragraph.dart';

class WreckingView extends GetView<WreckingController> {
  const WreckingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();
    return Scaffold(
        appBar: AppBar(
          title: MyParagraph(
            text: 'Component',
            fontSize: 65,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.barcode_reader),
              onPressed: () {
                controller.scanBarcode();
              },
            ),
          ],
        ),
        body: Obx(
          () => ListView(
              padding: EdgeInsets.all(ScreenAdapter.width(20)),
              children: [
                // Text(
                //   controller.barcodeTxt.value,
                //   style: TextStyle(fontSize: 20),
                // ),
                CardContainer(children: [
                  Padding(
                    padding: EdgeInsets.all(
                      ScreenAdapter.width(20),
                    ),
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              height: ScreenAdapter.height(86.4),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(43.2)),
                              child: TextField(
                                focusNode: _focusNode,
                                controller:
                                    controller.textEditingController.value,
                                onChanged: controller.onSearchChange,
                                style: TextStyle(fontFamily: "Roboto-Medium"),
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10)
                                          .copyWith(bottom: 6),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () async {
                          //     await controller.onSearch();
                          //     _focusNode.unfocus();
                          //   },
                          //   icon: Icon(
                          //     Icons.search,
                          //     color: AppColors.darkBlueColor,
                          //   ),
                          // ),
                        ],
                      ),
                      controller.wreckedData.value['disassemblyNumber'] != null
                          ? Column(
                              children: [
                                FilesMap(
                                  attribute: 'Number',
                                  value: controller
                                          .wreckedData['disassemblyNumber'] ??
                                      '----',
                                ),
                                FilesMap(
                                  attribute: 'Category',
                                  value: controller
                                          .wreckedData['disassemblyCategory'] ??
                                      '----',
                                ),
                                FilesMap(
                                  attribute: 'Info',
                                  value:
                                      "${controller.wreckedData['disassmblingInformation'] ?? '----'}",
                                  hasValue: controller
                                          .wreckedData['disassemblyCategory'] !=
                                      'Catalytic Converter',
                                ),
                                controller.wreckedData['disassemblyCategory'] ==
                                        'Catalytic Converter'
                                    ? ImagePickerWidget(
                                        onImagesChanged: controller.changeCC,
                                        images: controller.wreckedData[
                                            'disassmblingInformation'],
                                        isEditable: controller.isEdit.value,
                                      )
                                    : SizedBox(),
                                FilesMap(
                                  attribute: 'Description',
                                  value: controller.wreckedData[
                                          'disassemblyDescription'] ??
                                      '----',
                                ),
                                // FilesMap(
                                //   attribute: 'Disassembly images',
                                //   value: controller.wreckedData['disassemblyImages'] ?? '----',
                                // ),
                                FilesMap(
                                  attribute: 'Images',
                                  hasValue: false,
                                ),

                                ImagePickerWidget(
                                  onImagesChanged:
                                      controller.changeImageFileDir,
                                  images: controller.imageFileDir.value,
                                  isEditable: controller.isEdit.value,
                                ),
                                !controller.isMore.value
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                controller.isMore.value = true;
                                              },
                                              child: Text(
                                                "View car details  >>",
                                                style: TextStyle(
                                                    color: AppColors
                                                        .darkGreyColor),
                                              ))
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          FilesMap(
                                            attribute: 'Name',
                                            value: controller
                                                    .wreckedData['name'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Reg Num',
                                            value: controller.wreckedData[
                                                    'registrationNumber'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'State',
                                            value: controller
                                                    .wreckedData['state'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Brand',
                                            value: controller
                                                    .wreckedData['brand'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Model',
                                            value: controller
                                                    .wreckedData['model'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Year',
                                            value:
                                                "${controller.wreckedData['year'] ?? '----'}",
                                          ),
                                          FilesMap(
                                            attribute: 'Series',
                                            value: controller
                                                    .wreckedData['series'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Engine',
                                            value: controller
                                                    .wreckedData['engine'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Colour',
                                            value: controller
                                                    .wreckedData['colour'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Body Style',
                                            value: controller
                                                    .wreckedData['bodyStyle'] ??
                                                '----',
                                          ),
                                          FilesMap(
                                            attribute: 'Vin Number',
                                            value: controller
                                                    .wreckedData['vinNumber'] ??
                                                '----',
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    controller.isMore.value =
                                                        false;
                                                  },
                                                  child: Text(
                                                    "<<  Hide",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .darkGreyColor),
                                                  ))
                                            ],
                                          )
                                        ],
                                      )
                              ],
                            )
                          : EmptyStatus(title: 'No data')
                    ]),
                  )
                ])
              ]),
        ));
  }
}

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
