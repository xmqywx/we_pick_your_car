import 'dart:core';
import 'package:intl/intl.dart';

String handleFormatDateDDMMYYYY(dynamic date) {
  if (date == '0' || date == null) {
    return '--';
  }
  try {
    DateTime parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    parsedDate = parsedDate.add(Duration(hours: 8)); //添加时间
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
    parsedDate = parsedDate.add(Duration(hours: 8)); //添加时间
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
    parsedDate = parsedDate.add(Duration(hours: 8)); //添加时间
    return DateFormat('h:mm a', 'en_Us').format(parsedDate);
  } catch (error) {
    return '--';
  }
}
