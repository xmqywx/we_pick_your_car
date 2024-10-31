import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class Logo extends StatelessWidget {
  final double logoWidth;
  bool isDark;
  Logo(
      {super.key,
      this.logoWidth = 650,
      this.isDark = false}); // Increased default width

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(ScreenAdapter.width(0)),
      child: SizedBox(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(ScreenAdapter.width(0)),
          child: SizedBox(
            width: ScreenAdapter.width(logoWidth),
            child: isDark
                ? Image.asset("assets/images/pickYourCar.png",
                    fit: BoxFit.contain)
                : Image.asset("assets/images/apexpoint.png",
                    fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
