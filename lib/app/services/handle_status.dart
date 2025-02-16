import 'dart:core';
import 'package:flutter/material.dart';

// ignore: slash_for_doc_comments
/**
 * 状态：
 *    Completed 已完成 start有值，end有值
 *    Watting 未开始 expectedDate比现在的时间大，start和end为null或0
 *    Incomplete 未完成 expectedDate比现在的时间小一天，并且start和end为null或0
 *    In progress 进行中 start有值且start和expectedDate相差不久，end为null或0
 */
// const status = {
//   "Watting": {'color': "#7fa900"},
//   "In progress": {'color': "#df5286"},
//   "Completed": {'color': "#3b5bc2"},
//   "Incomplete": {'color': "#ea7a57"}
// };
const status = {
  0: {'color': "#ea7a57", 'message': "ea7a57"},
  1: {'color': "#FABE02", 'message': "Waiting"},
  2: {'color': "#df5286", 'message': "df5286"},
  3: {'color': "#ea7a57", 'message': "ea7a57"},
  4: {'color': "#C5D4FF", 'message': "Complete"},
  "Undefined status": {'color': "#ea7a57", 'message': "Undefined status"}
};
// String handleStatus(int leadStatus) {
//   return status[leadStatus]!['status'] ?? "Undefined status";
// }
String handleStatus(dynamic leadStatus) {
  int? statusIndex;
  if (leadStatus != null) {
    if (leadStatus is int) {
      statusIndex = leadStatus;
    } else if (leadStatus is String) {
      statusIndex = int.tryParse(leadStatus);
    }
  }

  if (statusIndex != null && status.containsKey(statusIndex)) {
    return status[statusIndex]!['message'] ?? "Undefined status";
  } else {
    return "Undefined status";
  }
}

Color handleStatusColor(String leadStatus) {
  for (final key in status.keys) {
    if (status[key]!['message'] == leadStatus) {
      final color = status[key]!['color'] ?? "#000000";
      return Color(int.parse(color.replaceAll('#', '0xFF')));
    }
  }
  return Colors.grey; // 如果没有匹配到，返回默认颜色
}
// Color handleStatusColor(dynamic leadStatus) {
//   if (leadStatus != null && status.containsKey(leadStatus)) {
//     final color = status[leadStatus]!['color'] ?? "#000000";
//     return Color(int.parse(color.replaceAll('#', '0xFF')));
//   } else {
//     return Colors.black;
//   }
// }
// class HandleStatus extends StatelessWidget {
//   final String? start;
//   final String? end;
//   final String? expectedDate;
//   const HandleStatus(
//       {super.key,
//       required this.start,
//       required this.end,
//       required this.expectedDate});

//   @override
//   Widget build(BuildContext context) {
//     final leadStatus = handleStatus(start, end, expectedDate);
//     Color statusColor = handleStatusColor(leadStatus);
//     return Container(
//       color: statusColor,
//       child: Text(
//         leadStatus,
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }


// String handleStatus(String? start, String? end, String? expectedDate) {
//   DateTime now = DateTime.now();

//   if ((start == null || start == '0') &&
//       (end == null || end == '0') &&
//       expectedDate != null) {
//     DateTime expected =
//         DateTime.fromMillisecondsSinceEpoch(int.parse(expectedDate));
//     if (expected != null && now.isBefore(expected)) {
//       return "Watting";
//     }
//   }
//   if (start != null && (end == null || end == '0')) {
//     DateTime startDate = DateTime.fromMillisecondsSinceEpoch(int.parse(start));
//     if (startDate != null && expectedDate != null) {
//       DateTime expected =
//           DateTime.fromMillisecondsSinceEpoch(int.parse(expectedDate));
//       if (expected != null &&
//           startDate.isBefore(expected) &&
//           now.isBefore(expected)) {
//         return "In progress";
//       }
//     }
//   }
//   if (start != null && (end != null && end != '0')) {
//     return "Completed";
//   }
//   if (expectedDate != null) {
//     DateTime expected =
//         DateTime.fromMillisecondsSinceEpoch(int.parse(expectedDate));
//     if (expected != null && now.isAfter(expected.subtract(Duration(days: 1)))) {
//       return "Incomplete";
//     }
//   }
//   return "Incomplete";
// }
