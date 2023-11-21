import 'package:car_wrecker/app/color/colors.dart';
import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/card_container.dart';
import '../../../const/wrecker.dart';
import '../../../text/paragraph.dart';

class ContainerCard extends StatelessWidget {
  final String containerNumber;
  String? sealNumber;
  final int status;
  String startDeliverTime;
  ContainerCard(
      {super.key,
      required this.containerNumber,
      required this.status,
      required this.startDeliverTime,
      this.sealNumber});

  @override
  Widget build(BuildContext context) {
    var statusMap = containerStatus[status];
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
                  text: containerNumber,
                  fontSize: 55,
                ),
              ),
              MyParagraph(
                text: statusMap?['label'] ?? '-error-',
                color: statusMap?['color'] ?? AppColors.redColor,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: MyParagraph(
                  text: "Commence date: ${startDeliverTime}",
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
