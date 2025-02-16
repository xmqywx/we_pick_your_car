// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

/// Example event class.
// class Event {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }
class Event {
  final String title;
  final int id;
  final String color;
  final String image;
  final int status;
  final String? expectedDate;
  final String? schedulerStart;
  final String? schedulerEnd;
  const Event(
      {required this.title,
      required this.id,
      required this.color,
      required this.image,
      required this.expectedDate,
      required this.schedulerEnd,
      required this.schedulerStart,
      required this.status});

  @override
  String toString() {
    return json.encode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'color': color,
      'image': image,
      'status': status,
      'expectedDate': expectedDate,
      'schedulerStart': schedulerStart,
      'schedulerEnd': schedulerEnd
    };
  }
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll({
//     kToday: [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
