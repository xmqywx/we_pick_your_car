import 'dart:collection';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../modules/tabs/controllers/tabs_controller.dart';
import './event.dart';
import 'dart:convert';
import '../services/handle_status.dart';
import '../services/screen_adapter.dart';
import '../services/format_date.dart';
import '../color/colors.dart';
import '../modules/home/controllers/home_controller.dart';
import 'dart:async';
import '../widget/imgErrorBuild.dart';

// TableBasicsExample()
class TableComplexExample extends StatefulWidget {
  final refresh;
  const TableComplexExample({super.key, required this.refresh});

  @override
  TableComplexExampleState createState() => TableComplexExampleState();
}

class TableComplexExampleState extends State<TableComplexExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  late PageController _pageController;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void initSelectedDays() {
    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
    _selectedEvents.value = _getEventsForDays(_selectedDays);
    Timer(Duration(milliseconds: 500), () {
      // 在这里写你想要执行的代码
      initSelectedDays();
      print('Timer triggered!');
    });
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;
  final TabsController myController = Get.find<TabsController>();
  final HomeController homeController = Get.find<HomeController>();
  List<Event> _getEventsForDay(DateTime day) {
    return myController.kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print(11234);
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  GlobalKey tableListKey = GlobalKey();
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
                ValueListenableBuilder<DateTime>(
                  valueListenable: _focusedDay,
                  builder: (context, value, _) {
                    return _CalendarHeader(
                      focusedDay: value,
                      clearButtonVisible: canClearSelection,
                      onTodayButtonTap: () {
                        setState(() => _focusedDay.value = DateTime.now());
                      },
                      onClearButtonTap: () {
                        setState(() {
                          _rangeStart = null;
                          _rangeEnd = null;
                          _selectedDays.clear();
                          _selectedEvents.value = [];
                        });
                      },
                      onLeftArrowTap: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      onRightArrowTap: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      reflashButton: () {
                        setState(() {
                          homeController.handleRefresh();
                          // _selectedEvents.value =
                          //     _getEventsForDays(_selectedDays);
                          Timer(Duration(milliseconds: 500), () {
                            // 在这里写你想要执行的代码
                            initSelectedDays();
                          });
                        });
                      },
                    );
                  },
                ),
                TableCalendar<Event>(
                  firstDay: kFirstDayOfWeek,
                  lastDay: kLastDayOfWeek,
                  focusedDay: _focusedDay.value,
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                      holidayTextStyle: TextStyle(color: Colors.deepOrange),
                      holidayDecoration: BoxDecoration(
                          color: Colors.transparent, shape: BoxShape.circle),
                      // Use `CalendarStyle` to customize the UI
                      outsideDaysVisible: true,
                      // outsideDecoration: BoxDecoration(
                      //   color: Colors.cyan,
                      // ),

                      markersMaxCount: 1,
                      selectedDecoration: BoxDecoration(
                        color: AppColors.themeColor1,
                        shape: BoxShape.circle,
                      ),

                      // outsideDecoration: ,
                      // markerSize: 10,
                      // markersAlignment: Alignment.bottomCenter,
                      // markerMargin: EdgeInsets.only(top: 8),
                      // cellMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      todayDecoration: BoxDecoration(
                        color: AppColors.subTextColor,
                        shape: BoxShape.circle,
                      ),
                      outsideTextStyle: TextStyle(color: AppColors.textColor),
                      // markerSizeScale: 5,
                      markerDecoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          shape: BoxShape.circle),
                      canMarkersOverflow: true),
                  selectedDayPredicate: (day) => _selectedDays.contains(day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  // 此处表示假期标红
                  // holidayPredicate: (day) {
                  //   // Every 20th day of the month will be treated as a holiday
                  //   return day.day == 20;
                  // },
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onCalendarCreated: (controller) =>
                      _pageController = controller,
                  onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                  onFormatChanged: (format) {
                    // Disable format change
                  },
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              key: tableListKey,
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    Map content = json.decode(value[index].toString());
                    var jobDetail = myController.jobsList.firstWhereOrNull((v) {
                      return v['id'] == content['id'];
                    });
                    if (jobDetail != null) {
                      // 处理找到的元素
                    } else {
                      // 处理找不到元素的情况
                    }
                    Color color = Color(
                        int.parse(content['color'].replaceAll('#', '0xFF')));
                    String imgAddr = content['image'];
                    // String schedulerStart =
                    // final curStatus = handleStatus(content['schedulerStart'],
                    //     content['schedulerEnd'], content['expectedDate']);
                    final curStatus = handleStatus(content['status']);
                    return Container(
                        margin: EdgeInsets.fromLTRB(ScreenAdapter.width(30), 10,
                            ScreenAdapter.width(30), 0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          // border: Border.all(
                          //     color: color, width: ScreenAdapter.width(3)),
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
                                      return ImgErrorBuild();
                                    },
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                  ScreenAdapter.width(8)),
                                              decoration: BoxDecoration(
                                                color: handleStatusColor(
                                                    curStatus),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenAdapter.width(4)),
                                              ),
                                              child: Text(
                                                curStatus,
                                                style: TextStyle(
                                                    fontFamily: "Roboto-Medium",
                                                    fontSize:
                                                        ScreenAdapter.fontSize(
                                                            30)),
                                              ),
                                            ),
                                            Text(
                                                handleFormatDateDDMMYYYY(
                                                    content['schedulerStart']),
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenAdapter.width(35),
                                                    color: AppColors
                                                        .themeTextColor2,
                                                    fontFamily:
                                                        "Roboto-Medium")),
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
                                                          ScreenAdapter.width(
                                                              40),
                                                      fontFamily:
                                                          "Roboto-Medium")),
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
                            // Get.toNamed("/pretreatment-detail",
                            //     arguments: jobDetail);
                            Get.toNamed(
                              "/job-details",
                              arguments: {
                                ...jobDetail,
                                "refresh": widget.refresh,
                              },
                            );
                          },
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;
  final VoidCallback reflashButton;
  const _CalendarHeader(
      {Key? key,
      required this.focusedDay,
      required this.onLeftArrowTap,
      required this.onRightArrowTap,
      required this.onTodayButtonTap,
      required this.onClearButtonTap,
      required this.clearButtonVisible,
      required this.reflashButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.today, color: AppColors.themeColor1),
          //   onPressed: onTodayButtonTap,
          //   tooltip: 'Go to today',
          // ),
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.darkGreenColor),
            onPressed: reflashButton,
            tooltip: 'Refresh',
          ),
          if (clearButtonVisible)
            IconButton(
              icon: Icon(Icons.close, color: AppColors.darkRedColor),
              onPressed: onClearButtonTap,
              tooltip: 'Clear selection',
            ),
          const Spacer(),
          // IconButton(
          //   icon: Icon(Icons.chevron_left, color: AppColors.darkBlueColor),
          //   onPressed: onLeftArrowTap,
          //   tooltip: 'Previous month',
          // ),
          // IconButton(
          //   icon: Icon(Icons.chevron_right, color: AppColors.darkBlueColor),
          //   onPressed: onRightArrowTap,
          //   tooltip: 'Next month',
          // ),
        ],
      ),
    );
  }
}
