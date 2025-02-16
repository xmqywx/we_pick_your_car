import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/format_date.dart';
import '../services/handle_status.dart';
import '../services/screen_adapter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../widget/image_preview_screen.dart';
import '../color/colors.dart';
import '../widget/license_plate.dart';
import '../widget/imgErrorBuild.dart';

class DetailTemplete extends StatefulWidget {
  final String customer_name;
  final String customer_phone_number;
  final String time_of_appointment;
  final String start_postion;
  final String end_position;
  final String cost;
  final String status;
  final String whether_to_pay;
  final arguments;
  final job_detail;
  const DetailTemplete(
      {super.key,
      required this.customer_name,
      required this.customer_phone_number,
      required this.time_of_appointment,
      required this.start_postion,
      required this.end_position,
      required this.cost,
      required this.status,
      required this.whether_to_pay,
      required this.job_detail,
      required this.arguments});

  @override
  State<DetailTemplete> createState() => _DetailTempleteState();
}

class _DetailTempleteState extends State<DetailTemplete> {
  @override
  Widget build(BuildContext context) {
    // final curStatus = handleStatus(widget.job_detail['schedulerStart'],
    //     widget.job_detail['schedulerEnd'], widget.time_of_appointment);]
    final curStatus = handleStatus(widget.job_detail['status']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyCard(
          children: [
            Container(
                color: handleStatusColor(curStatus),
                // height: ScreenAdapter.height(85),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(63),
                      ScreenAdapter.width(30),
                      ScreenAdapter.width(63),
                      ScreenAdapter.width(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: widget.start_postion != ""
                            ? InkWell(
                                child: Text(
                                  widget.start_postion,
                                  // overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: ScreenAdapter.fontSize(50),
                                      color: AppColors.textWhite),
                                ),
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      'https://maps.google.com/maps/search/?api=1&query=${widget.start_postion}');
                                  if (!await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                              )
                            : const Text("--"),
                      ),
                      SizedBox(
                        width: ScreenAdapter.width(80),
                        child: const Icon(Icons.my_location_outlined,
                            color: AppColors.textWhite),
                      ),
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(63),
                    ScreenAdapter.width(30),
                    ScreenAdapter.width(63),
                    ScreenAdapter.width(5)),
                child: Column(
                  children: [
                    InkWell(
                      child: SizedBox(
                          width: ScreenAdapter.width(585),
                          // height: ScreenAdapter.height(600),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              // border: Border.all(
                              //     color: Colors.grey,
                              //     width: 2,
                              //     style: BorderStyle.solid)
                            ),
                            child: widget.arguments['image'] != null
                                ? Image.network(
                                    widget.arguments['image'],
                                    fit: BoxFit.fitWidth,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const ImgErrorBuild();
                                    },
                                  )
                                : const Text(""),
                          )),
                      onTap: () {
                        Get.to(ImagePreviewScreen(
                          images: [widget.arguments['image'] ?? ""],
                          index: 0,
                        ));
                      },
                    ),
                    FilesMap(
                      attribute: 'Description',
                      value: "${widget.arguments['name'] ?? '--'}",
                    ),
                    FilesMap(
                        attribute: 'Reg. No.',
                        value:
                            "${widget.arguments['registrationNumber'] ?? '--'}",
                        valueWidget: LicensePlate(
                          widget: Text(
                              "${widget.arguments['registrationNumber'] ?? '--'}"),
                        )),
                    FilesMap(
                      attribute: 'BODY',
                      value: "${widget.arguments['bodyStyle'] ?? '--'}",
                    ),
                    FilesMap(
                        attribute: 'VIN',
                        value: "${widget.arguments['vinNumber'] ?? '--'}"),
                    FilesMap(
                      attribute: 'Engine',
                      value: "${widget.arguments['engine'] ?? '--'}",
                      flag: false,
                    ),
                  ],
                ))
          ],
        ),
        SizedBox(
          height: ScreenAdapter.height(20),
        ),
        MyCard(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(63),
                  ScreenAdapter.width(30),
                  ScreenAdapter.width(63),
                  ScreenAdapter.width(5)),
              child: Column(
                children: [
                  FilesMap(
                    attribute: 'Customer',
                    value: "${widget.arguments['firstName'] ?? '--'}",
                  ),
                  FilesMap(
                    attribute: 'Email',
                    value: "${widget.arguments['emailAddress'] ?? '--'}",
                  ),
                  // FilesMap(
                  //   attribute: 'Phone number',
                  //   value: "${widget.arguments['phoneNumber'] ?? '--'}",
                  // ),
                  Container(
                      constraints: const BoxConstraints(
                        minHeight: 25,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Phone',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      widget.arguments['phoneNumber']);
                                },
                                child: Text(
                                  "${widget.arguments['phoneNumber'] ?? '--'}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.darkBlueColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ))
        ]),
        SizedBox(
          height: ScreenAdapter.height(20),
        ),
        MyCard(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(63),
                  ScreenAdapter.width(30),
                  ScreenAdapter.width(63),
                  ScreenAdapter.width(5)),
              child: Column(
                children: [
                  FilesMap(
                    attribute: 'Start time',
                    value: widget.job_detail['schedulerStart'] != null
                        ? handleFormatDateDDMMYYYY(
                            widget.job_detail['schedulerStart'])
                        : '--',
                  ),
                  FilesMap(
                    attribute: 'End time',
                    value: widget.job_detail['schedulerEnd'] != null
                        ? handleFormatDateDDMMYYYY(
                            widget.job_detail['schedulerEnd'])
                        : '--',
                  ),
                  FilesMap(
                    attribute: 'Estimated price',
                    value: "\$${widget.arguments['recommendedPrice'] ?? '--'}",
                  ),
                  FilesMap(
                    attribute: 'Actual price',
                    value:
                        "\$${widget.arguments['actualPaymentPrice'] ?? '--'}",
                    flag: false,
                  ),
                ],
              ))
        ]),
      ],
    );
  }
}

// ------------------------
class FilesMap extends StatelessWidget {
  final String attribute;
  final String value;
  final bool flag;
  final Widget? keyWidget;
  final Widget? valueWidget;

  const FilesMap({
    Key? key,
    required this.attribute,
    required this.value,
    this.flag = true,
    this.keyWidget,
    this.valueWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget keyText = Text(
      attribute,
      textAlign: TextAlign.left,
      style: const TextStyle(),
    );
    Widget valueText = Text(
      value,
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.blueGrey),
    );

    if (keyWidget != null) {
      keyText = keyWidget!;
    }

    if (valueWidget != null) {
      valueText = valueWidget!;
    }

    return Container(
      constraints: const BoxConstraints(
        minHeight: 25,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: keyText),
              Flexible(child: valueText),
            ],
          ),
          flag
              ? Divider(
                  color: AppColors.black,
                  height: ScreenAdapter.height(35),
                  thickness: ScreenAdapter.height(3))
              : const SizedBox(),
        ],
      ),
    );
  }
}

// -----------------------
class MyCard extends StatelessWidget {
  final List<Widget> children;
  const MyCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 5,
      child: Column(
        children: children,
      ),
    ));
  }
}
