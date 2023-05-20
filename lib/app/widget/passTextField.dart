// import 'dart:ffi';

import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class PassTextFiled extends StatelessWidget {
  final bool isPassWord;
  final String hintText;
  final String label;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  const PassTextFiled(
      {super.key,
      this.controller,
      required this.hintText,
      required this.label,
      this.onChanged,
      this.isPassWord = false,
      this.keyboardType = TextInputType.number});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  $label",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Container(
          alignment: Alignment.center,
          height: ScreenAdapter.height(180),
          margin: EdgeInsets.only(
              top: ScreenAdapter.height(10), bottom: ScreenAdapter.height(40)),
          padding: EdgeInsets.only(left: ScreenAdapter.width(40)),
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(10)),
          child: TextField(
            // autofocus: true,
            controller: controller,
            obscureText: isPassWord,
            style: TextStyle(
                fontSize: ScreenAdapter.fontSize(48),
                fontFamily: "Roboto-Medium"),
            keyboardType: keyboardType, //默认弹出数字键盘
            decoration: InputDecoration(
                hintText: hintText, border: InputBorder.none //去掉下划线
                ),
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
