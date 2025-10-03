// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassSchedule _$ClassScheduleFromJson(Map<String, dynamic> json) =>
    ClassSchedule(
      id: json['id'] as String,
      courseCode: json['courseCode'] as String,
      courseName: json['courseName'] as String,
      instructor: json['instructor'] as String,
      room: json['room'] as String,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      startTime: const TimeOfDayConverter().fromJson(
        json['startTime'] as Map<String, dynamic>,
      ),
      endTime: const TimeOfDayConverter().fromJson(
        json['endTime'] as Map<String, dynamic>,
      ),
      description: json['description'] as String?,
      colorHex: json['colorHex'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      isRecurring: json['isRecurring'] as bool? ?? true,
      recurringWeeks: (json['recurringWeeks'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ClassScheduleToJson(ClassSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseCode': instance.courseCode,
      'courseName': instance.courseName,
      'instructor': instance.instructor,
      'room': instance.room,
      'dayOfWeek': instance.dayOfWeek,
      'startTime': const TimeOfDayConverter().toJson(instance.startTime),
      'endTime': const TimeOfDayConverter().toJson(instance.endTime),
      'description': instance.description,
      'colorHex': instance.colorHex,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'isRecurring': instance.isRecurring,
      'recurringWeeks': instance.recurringWeeks,
    };
