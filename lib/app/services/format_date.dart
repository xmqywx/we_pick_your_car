import 'dart:core';
import 'package:intl/intl.dart';

String handleFormatDateDDMMYYYY(dynamic date) {
  if (date == '0' || date == null) {
    return '--';
  }
  try {
    DateTime parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    parsedDate = parsedDate.add(const Duration(hours: 0)); //添加时间
    return DateFormat('dd-MM-yyyy HH:mm').format(parsedDate);
  } catch (error) {
    return '--';
  }
}

String handleFormatDateEEEEMMMMdyat(dynamic date) {
  if (date == '0' || date == null) {
    return '--';
  }
  try {
    DateTime parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    parsedDate = parsedDate.add(const Duration(hours: 0)); //添加时间
    return DateFormat('EEEE, MMMM d, \'at\' ', 'en_Us').format(parsedDate);
  } catch (error) {
    return '--';
  }
}

String handleFormathmma(dynamic date) {
  if (date == '0' || date == null) {
    return '--';
  }
  try {
    DateTime parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    parsedDate = parsedDate.add(const Duration(hours: 0)); //添加时间
    return DateFormat('h:mm a', 'en_Us').format(parsedDate);
  } catch (error) {
    return '--';
  }
}

DateTime handleParse({String? date, String format = 'dd-MM-yyyy'}) {
  if (date == null) return DateTime.now();
  return DateFormat(format).parse(date);
}

String handleFormat({DateTime? date, String format = 'dd-MM-yyyy'}) {
  if (date == null) return '----';
  return DateFormat(format).format(date);
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy').format(now);
  return formattedDate;
}
