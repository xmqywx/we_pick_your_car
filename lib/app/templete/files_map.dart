import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';
import '../color/colors.dart';

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
