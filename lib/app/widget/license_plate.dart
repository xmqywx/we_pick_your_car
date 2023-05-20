import 'package:flutter/material.dart';
import '../color/colors.dart';
import '../services/screen_adapter.dart';

class LicensePlate extends StatelessWidget {
  final Widget widget;
  const LicensePlate({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.logoBgc,
      padding: EdgeInsets.all(ScreenAdapter.width(3)),
      child: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(5)),
        decoration: BoxDecoration(
            border: Border.all(
                width: ScreenAdapter.width(6), color: AppColors.logoTxtc),
            borderRadius: BorderRadius.circular(ScreenAdapter.width(8))),
        child: widget,
      ),
    );
  }
}
