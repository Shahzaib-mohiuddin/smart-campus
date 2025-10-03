import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';

void main() {
  group('ClassSchedule', () {
    test('should create a class schedule with default values', () {
      final schedule = ClassSchedule(
        id: '1',
        courseCode: 'CS101',
        courseName: 'Introduction to Computer Science',
        instructor: 'Dr. Smith',
        room: 'A101',
        dayOfWeek: 1, // Monday
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        createdBy: 'test_user',
      );

      expect(schedule.id, '1');
      expect(schedule.courseCode, 'CS101');
      expect(schedule.courseName, 'Introduction to Computer Science');
      expect(schedule.instructor, 'Dr. Smith');
      expect(schedule.room, 'A101');
      expect(schedule.dayOfWeek, 1);
      expect(schedule.startTime, const TimeOfDay(hour: 9, minute: 0));
      expect(schedule.endTime, const TimeOfDay(hour: 10, minute: 30));
      expect(schedule.createdBy, 'test_user');
      expect(schedule.isRecurring, true);
      expect(schedule.recurringWeeks, isNull);
    });

    test('should convert to and from JSON', () {
      final createdAt = DateTime(2023, 1, 1);
      final updatedAt = DateTime(2023, 1, 1);
      
      final schedule = ClassSchedule(
        id: '1',
        courseCode: 'CS101',
        courseName: 'Introduction to Computer Science',
        instructor: 'Dr. Smith',
        room: 'A101',
        dayOfWeek: 1,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        description: 'Introduction to programming',
        colorHex: '#FF0000',
        createdBy: 'test_user',
        isRecurring: true,
        recurringWeeks: [1, 3, 5],
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Convert to JSON and back
      final json = schedule.toJson();
      final fromJson = ClassSchedule.fromJson(json);

      // Verify all fields are preserved
      expect(fromJson.id, schedule.id);
      expect(fromJson.courseCode, schedule.courseCode);
      expect(fromJson.courseName, schedule.courseName);
      expect(fromJson.instructor, schedule.instructor);
      expect(fromJson.room, schedule.room);
      expect(fromJson.dayOfWeek, schedule.dayOfWeek);
      expect(fromJson.startTime.hour, schedule.startTime.hour);
      expect(fromJson.startTime.minute, schedule.startTime.minute);
      expect(fromJson.endTime.hour, schedule.endTime.hour);
      expect(fromJson.endTime.minute, schedule.endTime.minute);
      expect(fromJson.description, schedule.description);
      expect(fromJson.colorHex, schedule.colorHex);
      expect(fromJson.isRecurring, schedule.isRecurring);
      expect(fromJson.recurringWeeks, schedule.recurringWeeks);
      expect(fromJson.createdBy, schedule.createdBy);
    });

    test('should create a copy with updated fields', () {
      final original = ClassSchedule(
        id: '1',
        courseCode: 'CS101',
        courseName: 'Introduction to Computer Science',
        instructor: 'Dr. Smith',
        room: 'A101',
        dayOfWeek: 1,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        createdBy: 'test_user',
      );

      final updated = original.copyWith(
        room: 'B202',
        instructor: 'Dr. Johnson',
      );

      // Updated fields should change
      expect(updated.room, 'B202');
      expect(updated.instructor, 'Dr. Johnson');
      
      // Other fields should remain the same
      expect(updated.id, original.id);
      expect(updated.courseCode, original.courseCode);
      expect(updated.courseName, original.courseName);
      expect(updated.dayOfWeek, original.dayOfWeek);
      expect(updated.startTime, original.startTime);
      expect(updated.endTime, original.endTime);
    });

    test('should check if class is happening now', () {
      final now = DateTime.now();
      final currentTime = TimeOfDay.fromDateTime(now);
      
      // Create a schedule for the current day and time
      final schedule = ClassSchedule(
        id: '1',
        courseCode: 'CS101',
        courseName: 'Current Class',
        instructor: 'Dr. Now',
        room: 'NOW101',
        dayOfWeek: now.weekday,
        startTime: TimeOfDay(hour: currentTime.hour, minute: 0),
        endTime: TimeOfDay(hour: currentTime.hour + 1, minute: 0),
        createdBy: 'test_user',
      );

      expect(schedule.isHappeningNow, true);
      expect(schedule.isUpcomingToday, false);
    });

    test('should check if class is upcoming today', () {
      final now = DateTime.now();
      final currentTime = TimeOfDay.fromDateTime(now);
      
      // Create a schedule for the current day but later time
      final schedule = ClassSchedule(
        id: '1',
        courseCode: 'CS101',
        courseName: 'Upcoming Class',
        instructor: 'Dr. Later',
        room: 'UP101',
        dayOfWeek: now.weekday,
        startTime: TimeOfDay(hour: currentTime.hour + 1, minute: 0),
        endTime: TimeOfDay(hour: currentTime.hour + 2, minute: 0),
        createdBy: 'test_user',
      );

      expect(schedule.isHappeningNow, false);
      expect(schedule.isUpcomingToday, true);
    });
  });
}
