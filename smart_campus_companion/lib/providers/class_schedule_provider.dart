import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';

class ClassScheduleProvider with ChangeNotifier {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'class_schedules';
  
  ClassScheduleProvider([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  // State
  List<ClassSchedule> _schedules = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<ClassSchedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Get schedules for a specific day
  List<ClassSchedule> getSchedulesForDay(int dayOfWeek) {
    return _schedules
        .where((schedule) => schedule.dayOfWeek == dayOfWeek)
        .toList()
      ..sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
  }
  
  // Get today's schedules
  List<ClassSchedule> getTodaysSchedules() {
    final today = DateTime.now().weekday;
    return getSchedulesForDay(today);
  }
  
  // Get upcoming classes (next 7 days)
  List<ClassSchedule> getUpcomingSchedules() {
    final now = DateTime.now();
    final currentDay = now.weekday;
    final currentTime = TimeOfDay.fromDateTime(now);
    
    final upcoming = <ClassSchedule>[];
    
    // Check next 7 days
    for (int i = 0; i < 7; i++) {
      final day = (currentDay + i - 1) % 7 + 1; // Wrap around to Monday after Sunday
      final daySchedules = getSchedulesForDay(day);
      
      for (final schedule in daySchedules) {
        // If it's today, only include future classes
        if (i == 0) {
          if (schedule.startTime.isAfter(currentTime)) {
            upcoming.add(schedule);
          }
        } else {
          upcoming.add(schedule);
        }
      }
    }
    
    return upcoming;
  }
  
  // Get current class (if any)
  ClassSchedule? getCurrentClass() {
    final now = DateTime.now();
    final currentDay = now.weekday;
    final currentTime = TimeOfDay.fromDateTime(now);
    
    return _schedules.firstWhere(
      (schedule) => 
          schedule.dayOfWeek == currentDay &&
          schedule.startTime.isBefore(currentTime) &&
          schedule.endTime.isAfter(currentTime),
      orElse: () => null as ClassSchedule,
    );
  }
  
  // Fetch all schedules for the current user
  Future<void> fetchSchedules({String? userId}) async {
    if (userId == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('createdBy', isEqualTo: userId)
          .orderBy('dayOfWeek')
          .orderBy('startTime.hour')
          .orderBy('startTime.minute')
          .get();
      
      _schedules = querySnapshot.docs
          .map((doc) => ClassSchedule.fromFirestore(doc))
          .toList();
      
      _error = null;
    } on FirebaseException catch (e) {
      _error = 'Failed to fetch schedules: ${e.message}';
      _schedules = [];
    } catch (e) {
      _error = 'An unexpected error occurred';
      _schedules = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Add a new schedule
  Future<bool> addSchedule(ClassSchedule schedule) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Check for schedule conflicts
      if (_hasScheduleConflict(schedule)) {
        _error = 'Schedule conflicts with an existing class';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      final docRef = await _firestore.collection(_collectionName).add(schedule.toFirestore());
      
      // Update the schedule with the generated ID
      final newSchedule = schedule.copyWith(id: docRef.id);
      _schedules.add(newSchedule);
      _sortSchedules();
      
      _error = null;
      return true;
    } on FirebaseException catch (e) {
      _error = 'Failed to add schedule: ${e.message}';
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update an existing schedule
  Future<bool> updateSchedule(ClassSchedule updatedSchedule) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Check for schedule conflicts (excluding the current schedule)
      if (_hasScheduleConflict(updatedSchedule, excludeScheduleId: updatedSchedule.id)) {
        _error = 'Schedule conflicts with an existing class';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      await _firestore
          .collection(_collectionName)
          .doc(updatedSchedule.id)
          .update(updatedSchedule.toFirestore()..['updatedAt'] = FieldValue.serverTimestamp());
      
      // Update the local list
      final index = _schedules.indexWhere((s) => s.id == updatedSchedule.id);
      if (index != -1) {
        _schedules[index] = updatedSchedule;
        _sortSchedules();
      }
      
      _error = null;
      return true;
    } on FirebaseException catch (e) {
      _error = 'Failed to update schedule: ${e.message}';
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Delete a schedule
  Future<bool> deleteSchedule(String scheduleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _firestore.collection(_collectionName).doc(scheduleId).delete();
      
      // Update the local list
      _schedules.removeWhere((s) => s.id == scheduleId);
      
      _error = null;
      return true;
    } on FirebaseException catch (e) {
      _error = 'Failed to delete schedule: ${e.message}';
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Check for schedule conflicts
  bool _hasScheduleConflict(ClassSchedule schedule, {String? excludeScheduleId}) {
    for (final existing in _schedules) {
      // Skip the schedule we're checking against (for updates)
      if (excludeScheduleId != null && existing.id == excludeScheduleId) {
        continue;
      }
      
      // Check if it's the same day
      if (existing.dayOfWeek == schedule.dayOfWeek) {
        // Check for time overlap
        final newStart = schedule.startTimeInMinutes;
        final newEnd = schedule.endTimeInMinutes;
        final existingStart = existing.startTimeInMinutes;
        final existingEnd = existing.endTimeInMinutes;
        
        // Check if the new schedule overlaps with the existing one
        if ((newStart >= existingStart && newStart < existingEnd) ||
            (newEnd > existingStart && newEnd <= existingEnd) ||
            (newStart <= existingStart && newEnd >= existingEnd)) {
          return true; // Conflict found
        }
      }
    }
    
    return false; // No conflicts
  }
  
  // Helper method to sort schedules
  void _sortSchedules() {
    _schedules.sort((a, b) {
      if (a.dayOfWeek != b.dayOfWeek) {
        return a.dayOfWeek.compareTo(b.dayOfWeek);
      } else if (a.startTimeInMinutes != b.startTimeInMinutes) {
        return a.startTimeInMinutes.compareTo(b.startTimeInMinutes);
      } else {
        return a.courseName.compareTo(b.courseName);
      }
    });
  }
  
  // Clear all data (for logout)
  void clear() {
    _schedules.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
