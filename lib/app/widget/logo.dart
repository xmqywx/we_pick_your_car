import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class Logo extends StatelessWidget {
  final double logoWidth;
  const Logo({super.key, this.logoWidth = 550});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(ScreenAdapter.width(40)),
      child: SizedBox(
          // width: ScreenAdapter.width(220),
          // height: ScreenAdapter.width(220),
          child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(ScreenAdapter.width(40)),
        child: SizedBox(
          width: ScreenAdapter.width(logoWidth),
          child:
              Image.asset("assets/images/pickYourCar.png", fit: BoxFit.cover),
        ),
      )),
    );
  }
}
