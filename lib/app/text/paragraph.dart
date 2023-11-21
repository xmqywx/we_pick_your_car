import 'dart:ffi';

import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';
import '../color/colors.dart';

class MyParagraph extends StatelessWidget {
  String text;
  String fontFamily;
  int fontSize;
  Color color;
  TextAlign align;
  FontWeight fontWeight;
  MyParagraph(
      {super.key,
      required this.text,
      this.fontFamily = 'Roboto-Medium',
      this.fontSize = 45,
      this.color = AppColors.themeTextColor1,
      this.align = TextAlign.left,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: ScreenAdapter.fontSize(fontSize),
          color: color,
          fontWeight: fontWeight),
    );
  }
}
