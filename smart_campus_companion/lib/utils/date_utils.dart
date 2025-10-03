import 'package:flutter/material.dart';

/// A collection of date and time utility functions
class DateUtils {
  /// Finds the next occurrence of a specific weekday from the given date
  /// [date] - The reference date
  /// [weekday] - The target weekday (1 = Monday, 7 = Sunday)
  static DateTime findNextWeekday(DateTime date, int weekday) {
    // Ensure weekday is in valid range
    final targetWeekday = weekday.clamp(1, 7);
    
    // Calculate days to add to reach the next occurrence of the target weekday
    int daysToAdd = (targetWeekday - date.weekday) % 7;
    
    // If today is the target weekday and the time has passed, go to next week
    if (daysToAdd == 0) {
      final now = TimeOfDay.fromDateTime(date);
      final targetTime = TimeOfDay(hour: 23, minute: 59); // End of day
      
      if (_isTimeOfDayAfter(now, targetTime)) {
        daysToAdd = 7; // Move to next week
      }
    }
    
    // If the calculated day is in the past, add a week
    if (daysToAdd < 0) {
      daysToAdd += 7;
    }
    
    return date.add(Duration(days: daysToAdd));
  }
  
  /// Gets the ISO week number for a given date
  /// [date] - The date to get the week number for
  /// Returns the ISO 8601 week number (weeks starting on Monday)
  static int getWeekNumber(DateTime date) {
    // Copy the date so we don't modify the original
    DateTime d = DateTime.utc(date.year, date.month, date.day);
    
    // ISO week number weeks start on Monday.
    // Week 1 is the week with the first Thursday of the year.
    
    // Set to nearest Thursday: current date + 4 - current day number
    // Make Sunday's day number 7
    int dayNumber = d.weekday == 7 ? 0 : d.weekday;
    d = d.add(Duration(days: 4 - dayNumber));
    
    // Get the first day of the year
    final yearStart = DateTime.utc(d.year, 1, 1);
    
    // Calculate the number of days between the first day of the year and our date
    final dayCount = d.difference(yearStart).inDays + 1;
    
    // Calculate the week number (adding 1 because we want 1-based index)
    final weekNumber = (dayCount / 7).ceil();
    
    return weekNumber;
  }
  
  /// Formats a duration in minutes to a human-readable string (e.g., "2h 30m")
  static String formatDuration(int totalMinutes) {
    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    }
    
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    if (minutes == 0) {
      return '${hours}h';
    }
    
    return '${hours}h ${minutes}m';
  }
  
  /// Gets the name of the month (e.g., "January", "February", etc.)
  static String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return months[month - 1];
  }
  
  /// Gets the short name of the month (e.g., "Jan", "Feb", etc.)
  static String getShortMonthName(int month) {
    return getMonthName(month).substring(0, 3);
  }
  
  /// Gets the name of the weekday (e.g., "Monday", "Tuesday", etc.)
  static String getWeekdayName(int weekday) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    
    return weekdays[weekday - 1];
  }
  
  /// Gets the short name of the weekday (e.g., "Mon", "Tue", etc.)
  static String getShortWeekdayName(int weekday) {
    return getWeekdayName(weekday).substring(0, 3);
  }
  
  /// Checks if two dates are on the same day
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  /// Checks if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }
  
  /// Checks if a date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }
  
  /// Checks if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }
  
  /// Checks if a date is in the current week
  static bool isInCurrentWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }
  
  /// Formats a date to a relative time string (e.g., "Today", "Tomorrow", "In 3 days")
  static String formatRelativeDate(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isTomorrow(date)) return 'Tomorrow';
    
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference > 0) {
      return 'In $difference ${difference == 1 ? 'day' : 'days'}';
    } else if (difference < 0) {
      final daysAgo = difference.abs();
      return '$daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago';
    }
    
    return 'Today';
  }
  
  // Helper method to check if a TimeOfDay is after another
  static bool _isTimeOfDayAfter(TimeOfDay a, TimeOfDay b) {
    if (a.hour > b.hour) return true;
    if (a.hour < b.hour) return false;
    return a.minute > b.minute;
  }
}
