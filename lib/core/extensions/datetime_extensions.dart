import 'package:flutter/material.dart';

extension DateTimeExtensionsForDateTime on DateTime {
  DateTime dayBeginning() {
    return DateTime(year, month, day);
  }

  DateTime dayEnding() {
    return DateTime(year, month, day + 1);
  }

  int get timestamp => millisecondsSinceEpoch;

  String get formattedDate {
    String day = this.day.toString();
    String month = this.month.toString();
    String year = this.year.toString();

    if (this.day < 10) {
      day = "0$day";
    }

    if (this.month < 10) {
      month = "0$month";
    }

    return "$day/$month/$year";
  }

  String get formattedDateTime {
    String day = this.day.toString();
    String month = this.month.toString();
    String year = this.year.toString();
    String hour = this.hour.toString();
    String minute = this.minute.toString();

    if (this.day < 10) {
      day = "0$day";
    }

    if (this.month < 10) {
      month = "0$month";
    }

    if (this.hour < 10) {
      hour = "0$hour";
    }

    if (this.minute < 10) {
      minute = "0$minute";
    }

    return "$day/$month/$year $hour:$minute";
  }

  String get formattedTime {
    String hour = this.hour.toString();
    String minute = this.minute.toString();

    if (this.hour < 10) {
      hour = "0$hour";
    }

    if (this.minute < 10) {
      minute = "0$minute";
    }

    return "$hour:$minute";
  }

  String get formattedDateReverse {
    String day = this.day.toString();
    String month = this.month.toString();
    String year = this.year.toString();

    if (this.day < 10) {
      day = "0$day";
    }

    if (this.month < 10) {
      month = "0$month";
    }
    return "$year/$month/$day";
  }
}

extension DateTimeExtensionsForTimeOfDay on TimeOfDay {
  String get formatted {
    String hour = this.hour.toString();
    String minute = this.minute.toString();

    if (this.hour < 10) {
      hour = "0$hour";
    }

    if (this.minute < 10) {
      minute = "0$minute";
    }

    return "$hour:$minute";
  }
}

extension DateTimeExtensionsForString on String {
  DateTime get toDateTime {
    String day = split("/")[0];
    String month = split("/")[1];
    String year = split("/")[2];

    return DateTime(
      int.parse(year),
      int.parse(month),
      int.parse(day),
    );
  }
}

extension DateTimeExtensionsForInt on int {
  DateTime toDateTime() => DateTime.fromMillisecondsSinceEpoch(this);
}
