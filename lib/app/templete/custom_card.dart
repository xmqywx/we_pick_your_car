import 'package:car_wrecker/app/color/colors.dart';
import 'package:flutter/material.dart';
import '../services/screen_adapter.dart';
import '../services/format_date.dart';
import '../services/handle_status.dart';
import 'package:get/get.dart';
import '../widget/imgErrorBuild.dart';

class CustomCard extends StatefulWidget {
  final String pickupAddress;
  final String expectedDate;
  final String engine;
  final String image;
  final String name;
  final String model;
  final String pickupAddressState;
  final int status;
  final arguments;
  const CustomCard(
      {super.key,
      required this.pickupAddress,
      required this.expectedDate,
      required this.engine,
      required this.image,
      required this.name,
      required this.model,
      required this.pickupAddressState,
      required this.status,
      required this.arguments});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    // final curStatus = handleStatus(widget.arguments['schedulerStart'],
    //     widget.arguments['schedulerEnd'], widget.arguments['expectedDate']);
    final curStatus = handleStatus(widget.status);
    Color color =
        Color(int.parse(widget.arguments['color'].replaceAll('#', '0xFF')));
    // Colors.black;
    return InkWell(
      child: Container(
        // color: Colors.white,
        margin: EdgeInsets.fromLTRB(
            ScreenAdapter.width(20),
            ScreenAdapter.height(15),
            ScreenAdapter.width(20),
            ScreenAdapter.width(0)),
        height: ScreenAdapter.height(280),
        child: Card(
            color: AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            // elevation: 5,
            child: Container(
                child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(ScreenAdapter.width(20.16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: ScreenAdapter.height(260),
                            width: ScreenAdapter.width(233.28),
                            margin: EdgeInsets.only(
                                right: ScreenAdapter.width(31.68)),
                            child: widget.image != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      // color: Color.fromRGBO(233, 222, 222, 1),
                                    ),
                                    child: Image.network(
                                      widget.image,
                                      fit: BoxFit.fitWidth,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return ImgErrorBuild();
                                      },
                                    ),
                                  )
                                : SizedBox(),
                          ),
                          Flexible(
                              flex: 1,
                              child: Container(
                                // padding: EdgeInsets.fromLTRB(0, ScreenAdapter.width(20),
                                //     ScreenAdapter.width(20), ScreenAdapter.width(20)),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      // height: ScreenAdapter.height(47),
                                      padding: EdgeInsets.all(
                                          ScreenAdapter.width(10)),
                                      // margin: EdgeInsets.only(
                                      //     bottom: ScreenAdapter.height(19)),
                                      decoration: BoxDecoration(
                                          color: handleStatusColor(curStatus),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenAdapter.height(12)))),
                                      child: Text(
                                        curStatus,
                                        style: TextStyle(
                                            color: AppColors.themeTextColor1,
                                            fontSize:
                                                ScreenAdapter.fontSize(28.8),
                                            fontFamily: "Roboto-Medium",
                                            height: 1),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: ScreenAdapter.width(20),
                                          height: ScreenAdapter.width(20),
                                          margin: EdgeInsets.only(
                                            right: ScreenAdapter.width(20),
                                          ),
                                          decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            widget.pickupAddress != ""
                                                ? widget.pickupAddress
                                                : "--",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenAdapter.fontSize(
                                                        40.32),
                                                // height: 1.5,
                                                fontFamily: "Roboto-Medium"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            widget.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize:
                                                  ScreenAdapter.fontSize(40.32),
                                              fontFamily: "Roboto-Medium",
                                              // height: 1.3
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      handleFormatDateDDMMYYYY(
                                          widget.arguments['schedulerStart']),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          // height: 1.3,
                                          fontSize:
                                              ScreenAdapter.fontSize(34.56),
                                          fontFamily: "Roboto-Medium"),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )),
                // Icon(
                //   Icons.location_on,
                //   size: ScreenAdapter.fontSize(40),
                //   color: color,
                // ),
                Image.asset(
                  "assets/images/icon_location.png",
                  width: ScreenAdapter.width(48.96),
                ),
                Container(
                  // width: ScreenAdapter.width(60),
                  margin: EdgeInsets.only(
                      right: ScreenAdapter.width(34.272),
                      left: ScreenAdapter.width(60)),
                  decoration: BoxDecoration(
                      // border: Border(
                      //     left: BorderSide(
                      //         color: Color.fromRGBO(222, 222, 222, 1),
                      //         width: 1)
                      //         )
                      ),
                  child: Center(
                    child: Icon(Icons.arrow_forward_ios_outlined,
                        size: ScreenAdapter.fontSize(40),
                        color: AppColors.themeTextColor1),
                  ),
                )
              ],
            ))),
      ),
      onTap: () {
        print(1111);
        Get.toNamed("/pretreatment-detail", arguments: widget.arguments);
      },
    );
  }
}
