import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../utils/time_of_day_converter.dart';

part 'class_schedule.g.dart';

/// Represents a class schedule in the application.
@JsonSerializable()
class ClassSchedule {
  /// Unique identifier for the schedule
  final String id;

  /// Course code (e.g., "CS101")
  final String courseCode;

  /// Full name of the course
  final String courseName;

  /// Name of the instructor
  final String instructor;

  /// Room number or location
  final String room;

  /// Day of the week (1-7, where 1 is Monday and 7 is Sunday)
  final int dayOfWeek;

  /// Start time of the class
  @TimeOfDayConverter()
  final TimeOfDay startTime;

  /// End time of the class
  @TimeOfDayConverter()
  final TimeOfDay endTime;

  /// Optional description of the class
  final String? description;

  /// Color code for UI theming
  final String? colorHex;

  /// When the schedule was created
  final DateTime createdAt;

  /// When the schedule was last updated
  final DateTime updatedAt;

  /// ID of the user who created the schedule
  final String createdBy;

  /// Whether the class repeats weekly
  final bool isRecurring;

  /// List of week numbers for recurring classes (e.g., [1,3,5] for odd weeks)
  final List<int>? recurringWeeks;

  ClassSchedule({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.instructor,
    required this.room,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.description,
    this.colorHex,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.createdBy,
    this.isRecurring = true,
    this.recurringWeeks,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
        
  /// Creates a copy of this class schedule with the given fields replaced by the non-null parameter values.
  ClassSchedule copyWith({
    String? id,
    String? courseCode,
    String? courseName,
    String? instructor,
    String? room,
    int? dayOfWeek,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? description,
    String? colorHex,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isRecurring,
    List<int>? recurringWeeks,
  }) {
    return ClassSchedule(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      instructor: instructor ?? this.instructor,
      room: room ?? this.room,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringWeeks: recurringWeeks ?? this.recurringWeeks,
    );
  }

  /// Creates a ClassSchedule from a JSON map
  factory ClassSchedule.fromJson(Map<String, dynamic> json) => 
      _$ClassScheduleFromJson(json);
      
  /// Converts the schedule to a JSON map
  Map<String, dynamic> toJson() => _$ClassScheduleToJson(this);
  
  /// Creates a ClassSchedule from a Firestore document
  factory ClassSchedule.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ClassSchedule(
      id: doc.id,
      courseCode: data['courseCode'] ?? '',
      courseName: data['courseName'] ?? '',
      instructor: data['instructor'] ?? '',
      room: data['room'] ?? '',
      dayOfWeek: data['dayOfWeek'] ?? 1,
      startTime: data['startTime'] != null
          ? TimeOfDayConverter().fromJson(
              Map<String, dynamic>.from(data['startTime']))
          : const TimeOfDay(hour: 9, minute: 0),
      endTime: data['endTime'] != null
          ? TimeOfDayConverter().fromJson(
              Map<String, dynamic>.from(data['endTime']))
          : const TimeOfDay(hour: 10, minute: 30),
      description: data['description'],
      colorHex: data['colorHex'],
      createdBy: data['createdBy'] ?? '',
      isRecurring: data['isRecurring'] ?? true,
      recurringWeeks: data['recurringWeeks']?.cast<int>(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  
  /// Converts the schedule to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'instructor': instructor,
      'room': room,
      'dayOfWeek': dayOfWeek,
      'startTime': TimeOfDayConverter().toJson(startTime),
      'endTime': TimeOfDayConverter().toJson(endTime),
      'description': description,
      'colorHex': colorHex,
      'isRecurring': isRecurring,
      'recurringWeeks': recurringWeeks,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
  
  /// Convert TimeOfDay to minutes since midnight for comparison
  int get startTimeInMinutes => startTime.hour * 60 + startTime.minute;
  
  /// Convert TimeOfDay to minutes since midnight for comparison
  int get endTimeInMinutes => endTime.hour * 60 + endTime.minute;
  
  /// Check if this class is happening now
  bool get isHappeningNow {
    final now = DateTime.now();
    final currentDay = now.weekday; // 1-7, where 1 is Monday
    final currentTime = TimeOfDay.fromDateTime(now);
    final currentTimeInMinutes = currentTime.hour * 60 + currentTime.minute;
    
    return dayOfWeek == currentDay && 
           startTimeInMinutes <= currentTimeInMinutes && 
           endTimeInMinutes >= currentTimeInMinutes;
  }
  
  /// Check if this class is upcoming today
  bool get isUpcomingToday {
    final now = DateTime.now();
    final currentDay = now.weekday;
    final currentTime = TimeOfDay.fromDateTime(now);
    final currentTimeInMinutes = currentTime.hour * 60 + currentTime.minute;
    
    return dayOfWeek == currentDay && startTimeInMinutes > currentTimeInMinutes;
  }
}
