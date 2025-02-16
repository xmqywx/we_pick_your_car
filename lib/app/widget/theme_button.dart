import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class PassButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const PassButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      height: ScreenAdapter.height(140),
      width: double.infinity,
      // width: ScreenAdapter.height(850),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(const Color.fromRGBO(240, 115, 49, 1)),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ScreenAdapter.height(70))))),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: ScreenAdapter.fontSize(46)),
        ),
      ),
    );
  }
}
