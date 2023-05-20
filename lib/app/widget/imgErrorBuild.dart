import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';

class ImgErrorBuild extends StatelessWidget {
  const ImgErrorBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Icon(
      Icons.car_crash_rounded,
      size: ScreenAdapter.fontSize(200),
    ));
  }
}
