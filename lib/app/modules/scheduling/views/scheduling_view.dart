import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scheduling_controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../services/screen_adapter.dart';
import '../../../color/colors.dart';
import 'dart:convert';
import '../../../services/handle_status.dart';
import '../../../widget/imgErrorBuild.dart';
import '../../../templete/event.dart';

class SchedulingView extends GetView<SchedulingController> {
  const SchedulingView({Key? key}) : super(key: key);

  Widget _buildCalendarHeader(
      {required focusedDay,
      required onLeftArrowTap,
      required onRightArrowTap,
      required onTodayButtonTap,
      required onClearButtonTap,
      required clearButtonVisible,
      required reflashButton}) {
    final headerText = DateFormat.yMMM().format(focusedDay);
    //     final DateTime focusedDay;
    // final VoidCallback onLeftArrowTap;
    // final VoidCallback onRightArrowTap;
    // final VoidCallback onTodayButtonTap;
    // final VoidCallback onClearButtonTap;
    // final bool clearButtonVisible;
    // final VoidCallback reflashButton;
    // const _CalendarHeader(
    //     {Key? key,
    //     required this.focusedDay,
    //     required this.onLeftArrowTap,
    //     required this.onRightArrowTap,
    //     required this.onTodayButtonTap,
    //     required this.onClearButtonTap,
    //     required this.clearButtonVisible,
    //     required this.reflashButton})
    //     : super(key: key);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 26.0),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTodayButtonTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Image.asset(
                  "assets/images/icon_date.png",
                  width: ScreenAdapter.fontSize(50),
                ),
              ),
            ),
          ),
          if (clearButtonVisible)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClearButtonTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  child: Image.asset(
                    "assets/images/icon_clear.png",
                    width: ScreenAdapter.fontSize(50),
                  ),
                ),
              ),
            ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: reflashButton,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Image.asset(
                  "assets/images/icon_refresh.png",
                  width: ScreenAdapter.fontSize(62),
                ),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            // color: AppColors.bgCard,
            margin: EdgeInsets.fromLTRB(ScreenAdapter.width(30),
                ScreenAdapter.width(30), ScreenAdapter.width(30), 0),
            decoration: BoxDecoration(
                // border: Border.all(
                //     width: ScreenAdapter.width(3), color: AppColors.textColor),
                color: AppColors.white,
                borderRadius: BorderRadius.circular(ScreenAdapter.width(20))),

            child: Column(
              children: [
                /// pao
                Obx(
                  () => _buildCalendarHeader(
                    focusedDay: controller.rxfocusedDay.value,
                    clearButtonVisible: controller.canClearSelection,
                    onTodayButtonTap: controller.onTodayButtonTap,
                    onClearButtonTap: controller.onClearButtonTap,
                    onLeftArrowTap: controller.onLeftArrowTap,
                    onRightArrowTap: controller.onRightArrowTap,
                    reflashButton: controller.reflashButton,
                  ),
                ),
                Obx(
                  () {
                    print(controller.rxselectedDays.value.length);

                    /// 跑一下,dianji shijian
                    return TableCalendar<Event>(
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: controller.rxfocusedDay.value,
                      headerVisible: false,
                      calendarStyle: CalendarStyle(
                          holidayTextStyle: const TextStyle(color: Colors.deepOrange),
                          holidayDecoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          // Use `CalendarStyle` to customize the UI
                          outsideDaysVisible: true,
                          // outsideDecoration: BoxDecoration(
                          //   color: Colors.cyan,
                          // ),
                          markersMaxCount: 1,
                          selectedDecoration: const BoxDecoration(
                            color: AppColors.themeColor1,
                            shape: BoxShape.circle,
                          ),

                          // outsideDecoration: ,
                          // markerSize: 10,
                          // markersAlignment: Alignment.bottomCenter,
                          // markerMargin: EdgeInsets.only(top: 8),
                          // cellMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          todayDecoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          outsideTextStyle:
                              const TextStyle(color: AppColors.outSideText),
                          // markerSizeScale: 5,
                          markerDecoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              shape: BoxShape.circle),
                          canMarkersOverflow: true),
                      //哪里，那个？
                      selectedDayPredicate: (day) =>
                          controller.rxselectedDays.value.contains(day),
                      rangeStartDay: controller.rxrangeStart.value,
                      rangeEndDay: controller.rxrangeEnd.value,
                      calendarFormat: controller.rxcalendarFormat.value,
                      rangeSelectionMode: controller.rxrangeSelectionMode.value,
                      eventLoader: controller.getEventsForDay,
                      holidayPredicate: (day) {
                        // Every 20th day of the month will be treated as a holiday
                        return day.day == 20;
                      },
                      onDaySelected: controller.onDaySelected,
                      onRangeSelected: controller.onRangeSelected,
                      onCalendarCreated: controller.onCalendarCreated,
                      onFormatChanged: controller.onFormatChanged,
                    );
                  },
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),

          /// ValueListenableBuilder remove ni cao zuo
          Obx(
            () => Expanded(
                child: ListView.builder(
              padding: EdgeInsets.only(bottom: ScreenAdapter.height(30)),
              itemCount: controller.rxselectedEvents.value.length,
              itemBuilder: (context, index) {
                Map content = json.decode(
                    controller.rxselectedEvents.value[index].toString());
                var jobDetail =
                    controller.myController.jobsList.firstWhereOrNull((v) {
                  return v['id'] == content['id'];
                });
                if (jobDetail != null) {
                  // 处理找到的元素
                } else {
                  // 处理找不到元素的情况
                }
                Color color =
                    Color(int.parse(content['color'].replaceAll('#', '0xFF')));
                String imgAddr = content['image'];
                // final curStatus = handleStatus(content['schedulerStart'],
                //     content['schedulerEnd'], content['expectedDate']);
                final curStatus = handleStatus(content['status']);
                return Container(
                    margin: EdgeInsets.fromLTRB(ScreenAdapter.width(30), 10,
                        ScreenAdapter.width(30), 0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                          color: color, width: ScreenAdapter.width(1)),
                      borderRadius:
                          BorderRadius.circular(ScreenAdapter.width(20)),
                    ),
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(ScreenAdapter.height(30)),
                        // margin: EdgeInsets.all(ScreenAdapter.height(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: ScreenAdapter.width(200),
                              margin: EdgeInsets.only(
                                  right: ScreenAdapter.width(10)),
                              child: Image.network(
                                imgAddr,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const ImgErrorBuild();
                                },
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                              ScreenAdapter.width(8)),
                                          decoration: BoxDecoration(
                                            color: handleStatusColor(curStatus),
                                            borderRadius: BorderRadius.circular(
                                                ScreenAdapter.width(4)),
                                          ),
                                          child: Text(
                                            curStatus,
                                            style: TextStyle(
                                                fontFamily: "Roboto-Medium",
                                                fontSize:
                                                    ScreenAdapter.fontSize(30)),
                                          ),
                                        ),
                                        // Text('24-04-2023',
                                        //     style: TextStyle(
                                        //         fontSize:
                                        //             ScreenAdapter.width(35),
                                        //         color:
                                        //             AppColors.themeTextColor2,
                                        //         fontFamily: "Roboto-Medium")),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenAdapter.height(10),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              '${content['title'] != "" ? content['title'] : "--"}',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenAdapter.width(40),
                                                  fontFamily: "Roboto-Medium")),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: ScreenAdapter.fontSize(50),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed("/pretreatment-detail",
                            arguments: jobDetail);
                      },
                    ));
              },
            )),
          )
        ],
      ),
    );
  }
}
