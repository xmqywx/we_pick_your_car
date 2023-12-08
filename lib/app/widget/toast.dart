import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../color/colors.dart';
import '../text/paragraph.dart';

const toStatus = {
  '1': AppColors.logoBgc,
  '2': AppColors.accentColor,
  '3': AppColors.darkRedColor
};

class CustomSnackbar extends StatelessWidget {
  final String? title;
  final String message;
  final String status;
  const CustomSnackbar(
      {Key? key, this.title, required this.message, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            // border: Border(
            //     left: BorderSide(
            //   color: Colors.yellow,
            //   width: 5.0,
            // )),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                  color: toStatus[status] ?? AppColors.logoBgc,
                  width: 5.0,
                )),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: TextStyle(
                        fontFamily: "Roboto-Medium",
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (title != null) SizedBox(height: 8.0),
                  Container(
                    width: ScreenAdapter.width(800),
                    child: MyParagraph(
                      text: message,
                      fontSize: 55,
                    ),
                  )
                ],
              ),
            ),
          ))
    ]);
  }
}

void showCustomSnackbar({
  String? title,
  required String message,
  String status = '1',
  Duration duration = const Duration(seconds: 2),
}) {
  if (Get.isSnackbarOpen) {
    Get.back();
    Get.closeAllSnackbars();
  }
  // Get.closeAllSnackbars();
  Get.snackbar('', '',
      duration: duration,
      // snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: Colors.transparent,
      messageText: CustomSnackbar(
        title: title,
        message: message,
        status: status,
      ),
      animationDuration: Duration(milliseconds: 200),
      barBlur: 0);
}

SnackbarController showCustomPrompt(
    {required Widget tipWidget,
    Duration? duration = const Duration(seconds: 2),
    double marginBottom = 200}) {
  if (Get.isSnackbarOpen) {
    Get.closeAllSnackbars();
  }
  return Get.snackbar('', '',
      duration: duration,
      margin: EdgeInsets.only(bottom: ScreenAdapter.width(marginBottom)),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
      messageText: tipWidget,
      dismissDirection: DismissDirection.horizontal,
      animationDuration: Duration(milliseconds: 200),
      barBlur: 0);
}
