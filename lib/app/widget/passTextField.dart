import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class PassTextFiled extends StatelessWidget {
  final bool isPassWord;
  final String hintText;
  final String label;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Color textColor; // New property for text color
  final Color hintTextColor; // New property for hint text color

  const PassTextFiled({
    super.key,
    this.controller,
    required this.hintText,
    required this.label,
    this.onChanged,
    this.isPassWord = false,
    this.keyboardType = TextInputType.number,
    this.textColor = Colors.black, // Default text color
    this.hintTextColor = Colors.grey, // Default hint text color
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  $label",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor, // Apply text color
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: ScreenAdapter.height(180),
          margin: EdgeInsets.only(
            top: ScreenAdapter.height(10),
            bottom: ScreenAdapter.height(40),
          ),
          padding: EdgeInsets.only(left: ScreenAdapter.width(40)),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassWord,
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(48),
              fontFamily: "Roboto-Medium",
              color: textColor, // Apply text color
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  TextStyle(color: hintTextColor), // Apply hint text color
              border: InputBorder.none, //去掉下划线
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
