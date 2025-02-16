// import 'package:flutter/material.dart';
// import '../services/screen_adapter.dart';
// import '../controllers/is_loading_controller.dart';
// import '../color/colors.dart';
// import 'package:get/get.dart';

// class PassButton extends StatelessWidget {
//   String text;
//   final void Function()? onPressed;
//   final bool withLoading;
//   final bool isBorder;
//   final bool disabled;
//   final Color btnBorderCorlor;
//   final Color btnColor;
//   final Color textColor;
//   IconData? icon;
//   double height;
//   double fontSize;
//   PassButton(
//       {super.key,
//       this.text = '',
//       required this.onPressed,
//       this.btnColor = AppColors.themeBtnColor,
//       this.textColor = AppColors.white,
//       this.btnBorderCorlor = AppColors.themeBtnColor,
//       this.isBorder = false,
//       this.withLoading = true,
//       this.height = 138,
//       this.fontSize = 52,
//       this.disabled = false,
//       this.icon});
//   final IsLoadingController isLoadingController =
//       Get.put(IsLoadingController());
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
//       height: ScreenAdapter.height(height),
//       // width: double.infinity,
//       // width: ScreenAdapter.height(850),
//       child: Opacity(
//         opacity: disabled ? 0.5 : 1,
//         child: ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(btnColor),
//                 foregroundColor: MaterialStateProperty.all(textColor),
//                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                     side: BorderSide(
//                       color: btnBorderCorlor,
//                       width: isBorder ? 2 : 0,
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(ScreenAdapter.height(23))))),
//             onPressed: () {
//               if (withLoading) {
//                 if (!isLoadingController.isLoading.value) {
//                   onPressed!();
//                 }
//               } else {
//                 onPressed!();
//               }
//               print(isLoadingController.isLoading.value);
//             },
//             child: Obx(() => withLoading
//                 ? !isLoadingController.isLoading.value
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           if (icon != null) Icon(icon),
//                           if (icon != null && text != '')
//                             SizedBox(
//                               width: ScreenAdapter.width(5),
//                             ),
//                           Text(
//                             text,
//                             style: TextStyle(
//                                 fontSize: ScreenAdapter.fontSize(fontSize)),
//                           )
//                         ],
//                       )
//                     : SizedBox(
//                         height: ScreenAdapter.height(80),
//                         width: ScreenAdapter.height(80),
//                         child: CircularProgressIndicator(
//                             color: AppColors.backgroundColor,
//                             strokeWidth: ScreenAdapter.width(10)),
//                       )
//                 : Text(
//                     text,
//                     style: TextStyle(fontSize: ScreenAdapter.fontSize(51.84)),
//                   ))),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';
import '../color/colors.dart';

class PassButton extends StatelessWidget {
  String text;
  final void Function()? onPressed;
  final bool withLoading;
  final bool isBorder;
  final bool disabled;
  final Color btnBorderCorlor;
  final Color btnColor;
  final Color textColor;
  IconData? icon;
  double height;
  double fontSize;
  final bool isLoading; // 新增参数，用于接收外部传入的isLoading状态

  PassButton({
    super.key,
    this.text = '',
    required this.onPressed,
    this.btnColor = AppColors.themeBtnColor,
    this.textColor = AppColors.white,
    this.btnBorderCorlor = AppColors.themeBtnColor,
    this.isBorder = false,
    this.withLoading = true,
    this.height = 138,
    this.fontSize = 52,
    this.disabled = false,
    this.icon,
    this.isLoading = false, // 初始化isLoading，默认为false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      height: ScreenAdapter.height(height),
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(btnColor),
            foregroundColor: WidgetStateProperty.all(textColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              side: BorderSide(
                color: btnBorderCorlor,
                width: isBorder ? 2 : 0,
              ),
              borderRadius: BorderRadius.circular(ScreenAdapter.height(23)),
            )),
          ),
          onPressed: () {
            if (withLoading && !isLoading) {
              onPressed!();
            } else if (!withLoading) {
              onPressed!();
            }
          },
          child: withLoading && isLoading
              ? SizedBox(
                  height: ScreenAdapter.height(80),
                  width: ScreenAdapter.height(80),
                  child: CircularProgressIndicator(
                      color: AppColors.backgroundColor,
                      strokeWidth: ScreenAdapter.width(10)),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) Icon(icon),
                    if (icon != null && text != '') SizedBox(width: ScreenAdapter.width(5)),
                    Text(
                      text,
                      style: TextStyle(fontSize: ScreenAdapter.fontSize(fontSize)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}