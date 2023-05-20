import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';
import '../controllers/is_loading_controller.dart';
import '../color/colors.dart';
import 'package:get/get.dart';

class PassButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool withLoading;
  final bool isBorder;
  final Color btnBorderCorlor;
  final Color btnColor;
  final Color textColor;
  PassButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.btnColor = AppColors.themeBtnColor,
      this.textColor = AppColors.white,
      this.btnBorderCorlor = AppColors.themeBtnColor,
      this.isBorder = false,
      this.withLoading = true});
  final IsLoadingController isLoadingController =
      Get.put(IsLoadingController());
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      height: ScreenAdapter.height(138),
      // width: double.infinity,
      // width: ScreenAdapter.height(850),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(btnColor),
              foregroundColor: MaterialStateProperty.all(textColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  side: BorderSide(
                    color: btnBorderCorlor,
                    width: isBorder ? 2 : 0,
                  ),
                  borderRadius:
                      BorderRadius.circular(ScreenAdapter.height(23))))),
          onPressed: () {
            if (withLoading) {
              if (!isLoadingController.isLoading.value) {
                onPressed!();
              }
            } else {
              onPressed!();
            }
            print(isLoadingController.isLoading.value);
          },
          child: Obx(() => withLoading
              ? !isLoadingController.isLoading.value
                  ? Text(
                      text,
                      style: TextStyle(fontSize: ScreenAdapter.fontSize(51.84)),
                    )
                  : SizedBox(
                      height: ScreenAdapter.height(80),
                      width: ScreenAdapter.height(80),
                      child: CircularProgressIndicator(
                          color: AppColors.backgroundColor,
                          strokeWidth: ScreenAdapter.width(10)),
                    )
              : Text(
                  text,
                  style: TextStyle(fontSize: ScreenAdapter.fontSize(51.84)),
                ))),
    );
  }
}
