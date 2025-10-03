import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// A [JsonConverter] that converts between [TimeOfDay] and [Map<String, dynamic>].
class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  /// Creates a new instance of [TimeOfDayConverter].
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay time) {
    return {
      'hour': time.hour,
      'minute': time.minute,
    };
  }
}

/// Extension methods for [TimeOfDay].
extension TimeOfDayExtension on TimeOfDay {
  /// Converts [TimeOfDay] to a formatted string.
  String format(BuildContext context) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  /// Checks if this time is after [other].
  bool isAfter(TimeOfDay other) {
    if (hour > other.hour) return true;
    if (hour == other.hour) return minute > other.minute;
    return false;
  }

  /// Checks if this time is before [other].
  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) return true;
    if (hour == other.hour) return minute < other.minute;
    return false;
  }

  /// Checks if this time is the same as [other].
  bool isAtSameMomentAs(TimeOfDay other) {
    return hour == other.hour && minute == other.minute;
  }
}

/// Gets the name of the day for the given [dayOfWeek].
String getDayName(int dayOfWeek) {
  switch (dayOfWeek) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return '';
  }
}
