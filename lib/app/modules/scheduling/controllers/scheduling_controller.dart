import 'package:get/get.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../tabs/controllers/tabs_controller.dart';
import 'dart:async';
import '../../home/controllers/home_controller.dart';
import '../../../templete/event.dart';

/// 不要使用ValuNotifier
class SchedulingController extends GetxController {
  //TODO: Implement SchedulingController
  late final RxList<Event> rxselectedEvents;
  final Rx<DateTime> rxfocusedDay = DateTime.now().obs;
  final Rx<Set<DateTime>> rxselectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  ).obs;
  final TabsController myController = Get.find<TabsController>();
  final HomeController homeController = Get.find<HomeController>();

  late Rx<PageController> rxpageController;
  Rx<CalendarFormat> rxcalendarFormat = CalendarFormat.month.obs;
  Rx<RangeSelectionMode> rxrangeSelectionMode =
      RangeSelectionMode.toggledOff.obs;
  Rx<DateTime?> rxrangeStart = null.obs;
  Rx<DateTime?> rxrangeEnd = null.obs;
  bool get canClearSelection =>
      rxselectedDays.value.isNotEmpty ||
      rxrangeStart.value != null ||
      rxrangeEnd.value != null;
  // -------------------------------- 改动
  /**
   * List<Event> _getEventsForDay(DateTime day) {
return myController.kEvents.value[day] ?? [];
}
   * 
   */
  List<Event> getEventsForDay(DateTime day) {
    // List<Event> events = [];
    // if (myController.kEvents.containsKey(day)) {
    //   events = List<Event>.from(myController.kEvents[day]!);
    // }
    // print('-*-*-*-*-*-*-*-*-*-*-*-*-*-*-');
    // print(events);
    // return events;

    return myController.kEvents[day] ?? [];
  }

  // -------------------------------- 改动
  void initSelectedDays() {
    rxselectedEvents.value = _getEventsForDays(rxselectedDays.value);
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  /// 这里是吧
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (rxselectedDays.value.contains(selectedDay)) {
      rxselectedDays.value.remove(selectedDay);
    } else {
      rxselectedDays.value.add(selectedDay);
    }
    print(rxselectedDays.value.length);

    rxselectedDays.refresh();

    rxfocusedDay.value = focusedDay;
    rxrangeStart.value = null;
    rxrangeEnd.value = null;
    rxrangeSelectionMode.value = RangeSelectionMode.toggledOff;

    rxselectedEvents.value = _getEventsForDays(rxselectedDays.value);
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    rxfocusedDay.value = focusedDay;
    rxrangeStart.value = start;
    rxrangeEnd.value = end;
    rxselectedDays.value.clear();
    rxrangeSelectionMode.value = RangeSelectionMode.toggledOn;

    if (start != null && end != null) {
      rxselectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      rxselectedEvents.value = getEventsForDay(start);
    } else if (end != null) {
      rxselectedEvents.value = getEventsForDay(end);
    }
  }

// ---------------------------
  void onTodayButtonTap() {
    rxfocusedDay.value = DateTime.now();
  }

  void onClearButtonTap() {
    rxrangeStart.value = null;
    rxrangeEnd.value = null;
    rxselectedDays.value.clear();
    // pao
    rxselectedDays.refresh();
  }

  void onLeftArrowTap() {
    rxpageController.value.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void onRightArrowTap() {
    rxpageController.value.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void reflashButton() {
    homeController.handleRefresh();
    Timer(const Duration(milliseconds: 500), () {
      initSelectedDays();
    });
  }

  void onCalendarCreated(controller) {
    rxpageController = Rx(controller);
  }

  void onFormatChanged(format) {
    if (rxcalendarFormat.value != format) {
      rxcalendarFormat.value = format;
    }
  }

  @override
  void onInit() {
    super.onInit();

    rxselectedDays.value.add(rxfocusedDay.value);
    rxselectedEvents = getEventsForDay(rxfocusedDay.value).obs;
    rxselectedEvents.value = _getEventsForDays(rxselectedDays.value);
    Timer(const Duration(milliseconds: 500), () {
      initSelectedDays();
    });
  }


}
