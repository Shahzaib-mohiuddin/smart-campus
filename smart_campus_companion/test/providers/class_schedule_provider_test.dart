import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_campus_companion/providers/class_schedule_provider.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';
import 'dart:async';

// Mock classes
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) => 
      MockCollectionReference();
}

class MockCollectionReference extends Mock 
    implements CollectionReference<Map<String, dynamic>> {
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) => 
      MockDocumentReference();
  
  @override
  Future<DocumentReference<Map<String, dynamic>>> add(Map<String, dynamic> data) =>
      Future.value(MockDocumentReference());
  
  @override
  Query<Map<String, dynamic>> where(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) => MockQuery();
}

class MockDocumentReference extends Mock 
    implements DocumentReference<Map<String, dynamic>> {
  @override
  String get id => 'test_id';
  
  @override
  Future<void> update(Map<Object, Object?> data) => Future.value();
  
  @override
  Future<void> delete() => Future.value();
  
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) => 
      Future.value(MockDocumentSnapshot());
}

class MockDocumentSnapshot extends Mock 
    implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  String get id => 'test_id';
  
  @override
  Map<String, dynamic>? data() => {};
  
  @override
  bool get exists => true;
}

class MockQuerySnapshot extends Mock 
    implements QuerySnapshot<Map<String, dynamic>> {
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => [];
}

class MockQueryDocumentSnapshot extends Mock 
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  @override
  String get id => 'test_id';
  
  @override
  Map<String, dynamic> data() => {};
}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {
  @override
  Query<Map<String, dynamic>> where(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) => this;
  
  @override
  Query<Map<String, dynamic>> orderBy(
    Object field, {
    bool descending = false,
  }) => this;
  
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) => 
      Future.value(MockQuerySnapshot());
}

// Helper function to create a test schedule
ClassSchedule createTestSchedule({
  String? id,
  String courseCode = 'CS101',
  String courseName = 'Introduction to CS',
  String instructor = 'Dr. Smith',
  String room = 'A101',
  int dayOfWeek = 1,
  TimeOfDay? startTime,
  TimeOfDay? endTime,
  String? description,
  String? colorHex,
  bool isRecurring = true,
  List<int>? recurringWeeks,
  String? createdBy,
}) {
  return ClassSchedule(
    id: id ?? 'test_id',
    courseCode: courseCode,
    courseName: courseName,
    instructor: instructor,
    room: room,
    dayOfWeek: dayOfWeek,
    startTime: startTime ?? const TimeOfDay(hour: 9, minute: 0),
    endTime: endTime ?? const TimeOfDay(hour: 10, minute: 30),
    description: description,
    colorHex: colorHex,
    isRecurring: isRecurring,
    recurringWeeks: recurringWeeks,
    createdBy: createdBy ?? 'test_user',
  );
}

void main() {
  // Setup
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocumentReference;
  late MockQuery mockQuery;
  late ClassScheduleProvider provider;
  
  // Constants
  const testUserId = 'test_user_id';
  
  setUp(() {
    // Initialize mocks
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockQuery = MockQuery();
    
    // Setup default mock behavior
    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocumentReference);
    when(() => mockDocumentReference.id).thenReturn('test_id');
    when(() => mockCollection.add(any())).thenAnswer((_) => Future.value(mockDocumentReference));
    when(() => mockDocumentReference.update(any())).thenAnswer((_) => Future.value());
    when(() => mockDocumentReference.delete()).thenAnswer((_) => Future.value());
    when(() => mockQuery.get()).thenAnswer((_) => Future.value(MockQuerySnapshot()));
    
    // Initialize provider with mock Firestore instance
    provider = ClassScheduleProvider(mockFirestore);
  });
  
  group('ClassScheduleProvider', () {
    test('addSchedule should add a new schedule', () async {
      // Arrange
      final testSchedule = createTestSchedule();
      when(() => mockCollection.add(any())).thenAnswer(
        (_) => Future.value(mockDocumentReference),
      );
      
      // Act
      final result = await provider.addSchedule(testSchedule);
      
      // Assert
      expect(result, isTrue);
      verify(() => mockCollection.add(any())).called(1);
    });
    
    test('updateSchedule should update an existing schedule', () async {
      // Arrange
      final testSchedule = createTestSchedule();
      when(() => mockDocumentReference.update(any())).thenAnswer(
        (_) => Future.value(),
      );
      
      // Act
      final result = await provider.updateSchedule(testSchedule);
      
      // Assert
      expect(result, isTrue);
      verify(() => mockDocumentReference.update(any())).called(1);
    });
    
    test('deleteSchedule should delete a schedule', () async {
      // Arrange
      const scheduleId = 'test_schedule_id';
      when(() => mockDocumentReference.delete()).thenAnswer(
        (_) => Future.value(),
      );
      
      // Act
      final result = await provider.deleteSchedule(scheduleId);
      
      // Assert
      expect(result, isTrue);
      verify(() => mockDocumentReference.delete()).called(1);
    });
    
    test('getTodaysSchedules should return today\'s schedules', () async {
      // Arrange
      final today = DateTime.now().weekday;
      final todaySchedule = createTestSchedule(dayOfWeek: today);
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      
      when(() => mockCollection.where(
        any(),
        isEqualTo: any(named: 'isEqualTo'),
      )).thenReturn(mockQuery);
      
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data()).thenReturn({
        'id': todaySchedule.id,
        'courseCode': todaySchedule.courseCode,
        'courseName': todaySchedule.courseName,
        'instructor': todaySchedule.instructor,
        'room': todaySchedule.room,
        'dayOfWeek': todaySchedule.dayOfWeek,
        'startTime': {'hour': 9, 'minute': 0},
        'endTime': {'hour': 10, 'minute': 30},
        'isRecurring': todaySchedule.isRecurring,
        'createdBy': todaySchedule.createdBy,
      });
      when(() => mockQueryDocSnapshot.id).thenReturn(todaySchedule.id);
      
      // First fetch schedules
      await provider.fetchSchedules(userId: 'test_user');
      
      // Act
      final todaysSchedules = provider.getTodaysSchedules();
      
      // Assert
      expect(todaysSchedules, isNotEmpty);
      expect(todaysSchedules.first.dayOfWeek, today);
    });
  });

  tearDown(() {
    reset(mockFirestore);
    reset(mockCollection);
    reset(mockDocumentReference);
    reset(mockQuery);
  });
}
