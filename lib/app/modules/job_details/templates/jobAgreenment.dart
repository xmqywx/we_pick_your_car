import 'package:flutter/material.dart';
import '../../../services/screen_adapter.dart';
import '../../../color/colors.dart';
import '../../../text/paragraph.dart';

class JobAgreenment extends StatefulWidget {
  final Function agreen;
  final Function cancel;
  JobAgreenment({super.key, required this.agreen, required this.cancel});

  @override
  State<JobAgreenment> createState() => _JobAgreenmentState();
}

class _JobAgreenmentState extends State<JobAgreenment> {
  @override
  Widget build(BuildContext context) {
    bool _isChecked = false;
    return Container(
      height: ScreenAdapter.height(2000),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenAdapter.fontSize(20))),
          border: Border.all(color: AppColors.accent)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Transform(
                  transform: Matrix4.skew(-0.4, 0),
                  child: Container(
                    height: ScreenAdapter.width(20),
                    width: ScreenAdapter.width(600),
                    color: AppColors.accent,
                  ))
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: MyParagraph(
              text: "We Pick Your Car",
              fontSize: 70,
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(horizontal: ScreenAdapter.width(35)),
                  child: MyParagraph(
                    text:
                        """For the exact sales amount indicated below, I the seller to hereby sell and transfer ownership of the vehicle described to the buyer, acknowledge for receipt of payment certify that I have the authority to sell it. Warrant the vehicle to be free of any loans and encumbrances and certified that all information given is true incorrect to the best of my knowledge.""",
                    fontSize: 60,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    widget.cancel();
                  },
                  child: Row(
                    children: [
                      // Icon(Icons.arrow_back_sharp),
                      MyParagraph(text: "Cancel")
                    ],
                  )),
              // SizedBox(
              //   width: ScreenAdapter.width(380),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       SizedBox(
              //         child: MyParagraph(
              //           text: 'Agreen',
              //         ),
              //       ),
              //       Checkbox(
              //         value: _isChecked,
              //         onChanged: (bool? value) {
              //           print(value);
              //           setState(() {
              //             if (value != null) _isChecked = value;
              //           });

              //           if (_isChecked == true) {
              //             widget.agreen();
              //           }
              //         },
              //       ),
              //       SizedBox(width: ScreenAdapter.width(35)), // 设置合适的间距
              //     ],
              //   ),
              // ),
              TextButton(
                  onPressed: () {
                    widget.agreen();
                    // if (Get.isSnackbarOpen) {
                    //   Get.closeAllSnackbars();
                    // }
                    // Get.bottomSheet(
                    //   Container(
                    //     height: ScreenAdapter.height(2000),
                    //     // color: Colors.red,
                    //     child: GenerateSignature(
                    //       changeSignature: changeSignature,
                    //     ),
                    //   ),
                    //   enableDrag: false,
                    //   isScrollControlled: true,
                    // );
                  },
                  child: Row(
                    children: [
                      MyParagraph(
                        text: "Agreen",
                        color: AppColors.accent,
                      ),
                      // Icon(Icons.arrow_forward)
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
