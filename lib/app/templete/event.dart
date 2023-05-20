import 'dart:convert';

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
