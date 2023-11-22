import 'package:flutter/material.dart';
import 'package:car_wrecker/app/color/colors.dart';
import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:get/get.dart';
import '../../../widget/card_container.dart';
import '../../../const/wrecker.dart';
import '../../../text/paragraph.dart';
import '../../../widget/photo_upload.dart';
import 'dart:convert';

class ComponentCard extends StatelessWidget {
  final String containerNumber;
  final String disassmblingInformation;
  final String disassemblyNumber;
  final String category;
  const ComponentCard({
    super.key,
    required this.containerNumber,
    required this.disassmblingInformation,
    required this.category,
    required this.disassemblyNumber,
  });

  @override
  Widget build(BuildContext context) {
    List<String> imagesFile = <String>[];
    print('category == Catalytic Converter');
    print(category == 'Catalytic Converter');
    if (category == 'Catalytic Converter') {
      List cloneData = [];
      try {
        cloneData = json
            .decode(disassmblingInformation)
            .map((e) => e.toString())
            .toList();
      } catch (e) {
        cloneData = [];
      }
      imagesFile = cloneData.cast<String>().toList();
    }
    return Container(
      width: double.infinity,
      // height: 300,
      child: CardContainer(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: MyParagraph(
                  text: disassemblyNumber,
                  fontSize: 55,
                ),
              ),
              // MyParagraph(
              //   text: statusMap?['label'] ?? '-error-',
              //   color: statusMap?['color'] ?? AppColors.redColor,
              // )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: category == 'Catalytic Converter'
              ? Column(
                  children: [
                    ImagePickerWidget(
                      onImagesChanged: (list) {},
                      images: imagesFile,
                      isEditable: false,
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: MyParagraph(
                        text: disassmblingInformation,
                        fontSize: 40,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_outlined,
                      size: ScreenAdapter.fontSize(50),
                    )
                  ],
                ),
        ),
      ]),
    );
  }
}
