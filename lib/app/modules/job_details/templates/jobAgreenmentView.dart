import 'package:flutter/material.dart';
import '../../../services/screen_adapter.dart';
import '../../../color/colors.dart';
import '../../../text/paragraph.dart';

class JobAgreenmentView extends StatefulWidget {
  const JobAgreenmentView({super.key});

  @override
  State<JobAgreenmentView> createState() => _JobAgreenmentViewState();
}

class _JobAgreenmentViewState extends State<JobAgreenmentView> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    return Container(
      margin: EdgeInsets.only(bottom: ScreenAdapter.width(15)),
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
            padding: EdgeInsets.only(top: ScreenAdapter.width(15)),
            child: MyParagraph(
              text: "Contract of Sale - Agreement",
              fontSize: 55,
              height: 1.5,
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(20),
          ),
          Container(
            padding: EdgeInsets.only(bottom: ScreenAdapter.width(45)),
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.width(70)),
            child: MyParagraph(
              height: 1.5,
              text:
                  """For the exact sales amount indicated below, I the seller to hereby sell and transfer ownership of the vehicle described to the buyer, acknowledge for receipt of payment certify that I have the authority to sell it. Warrant the vehicle to be free of any loans and encumbrances and certified that all information given is true incorrect to the best of my knowledge.""",
              fontSize: 45,
            ),
          )
        ],
      ),
    );
  }
}
