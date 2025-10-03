import 'package:flutter/material.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';
import 'package:smart_campus_companion/theme/app_theme.dart';
import 'package:smart_campus_companion/utils/date_utils.dart' as app_date_utils;

class UpcomingClassesList extends StatelessWidget {
  final List<ClassSchedule> upcomingClasses;
  final ValueChanged<ClassSchedule>? onClassTap;
  final bool showDayHeaders;
  
  const UpcomingClassesList({
    super.key,
    required this.upcomingClasses,
    this.onClassTap,
    this.showDayHeaders = true,
  });
  
  @override
  Widget build(BuildContext context) {
    if (upcomingClasses.isEmpty) {
      return _buildEmptyState(context);
    }
    
    // Group classes by day
    final Map<DateTime, List<ClassSchedule>> classesByDay = {};
    final now = DateTime.now();
    
    for (final classItem in upcomingClasses) {
      // Find the next occurrence of this class day
      DateTime classDate = app_date_utils.DateUtils.findNextWeekday(
        now, 
        classItem.dayOfWeek,
      );
      
      // If it's a recurring class, make sure we have the right week
      if (classItem.isRecurring && classItem.recurringWeeks != null) {
        final weekNumber = app_date_utils.DateUtils.getWeekNumber(now);
        final weekInSchedule = weekNumber % classItem.recurringWeeks!.length;
        
        // Adjust the date to the correct week in the schedule
        if (classItem.recurringWeeks![weekInSchedule] != weekNumber) {
          // Find the next occurrence in the schedule
          int weeksToAdd = 1;
          while (true) {
            final nextWeekNumber = (weekNumber + weeksToAdd) % classItem.recurringWeeks!.length;
            if (classItem.recurringWeeks!.contains(nextWeekNumber)) {
              classDate = classDate.add(Duration(days: 7 * weeksToAdd));
              break;
            }
            weeksToAdd++;
          }
        }
      }
      
      // Create a date-only key for grouping
      final dateOnly = DateTime(classDate.year, classDate.month, classDate.day);
      
      if (!classesByDay.containsKey(dateOnly)) {
        classesByDay[dateOnly] = [];
      }
      
      classesByDay[dateOnly]!.add(classItem);
    }
    
    // Sort days
    final sortedDays = classesByDay.keys.toList()..sort();
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedDays.length,
      itemBuilder: (context, dayIndex) {
        final day = sortedDays[dayIndex];
        final dayClasses = classesByDay[day]!..sort((a, b) => a.startTimeInMinutes.compareTo(b.startTimeInMinutes));
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDayHeaders) ...[
              _buildDayHeader(context, day),
              const SizedBox(height: 8),
            ],
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayClasses.length,
              itemBuilder: (context, classIndex) {
                final classItem = dayClasses[classIndex];
                return _buildClassItem(context, classItem);
              },
            ),
            
            if (dayIndex < sortedDays.length - 1) 
              const SizedBox(height: 16),
          ],
        );
      },
    );
  }
  
  Widget _buildDayHeader(BuildContext context, DateTime date) {
    final theme = Theme.of(context);
    final isToday = _isSameDay(date, DateTime.now());
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            _getWeekdayName(date.weekday),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isToday ? theme.colorScheme.primary : null,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${date.day} ${_getMonthName(date.month)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (isToday) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Today',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildClassItem(BuildContext context, ClassSchedule classItem) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isHappeningNow = classItem.isHappeningNow;
    final isUpcomingToday = classItem.isUpcomingToday;
    
    final cardColor = classItem.colorHex != null
        ? Color(int.parse('0xFF${classItem.colorHex!}'))
        : colorScheme.primaryContainer;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHappeningNow
            ? BorderSide(color: colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      elevation: isHappeningNow ? 2 : 0,
      child: InkWell(
        onTap: () => onClassTap?.call(classItem),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: cardColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with time and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_formatTime(classItem.startTime)} - ${_formatTime(classItem.endTime)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isHappeningNow)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              'Now',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (isUpcomingToday)
                      Text(
                        'Up next',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Course code and name
                Text(
                  classItem.courseCode,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  classItem.courseName,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Details row
                Row(
                  children: [
                    _buildDetailChip(
                      context,
                      icon: Icons.person_outline,
                      label: classItem.instructor,
                    ),
                    const SizedBox(width: 8),
                    _buildDetailChip(
                      context,
                      icon: Icons.room_outlined,
                      label: classItem.room,
                    ),
                    if (classItem.isRecurring) ...[
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        context,
                        icon: Icons.repeat_outlined,
                        label: 'Recurring',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 64,
              color: colorScheme.primary.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No upcoming classes',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your upcoming classes will appear here',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }
  
  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}

// Helper extension for TimeOfDay
// extension TimeOfDayExtension on TimeOfDay {
//   bool get isBeforeNow {
//     final now = TimeOfDay.now();
//     return hour < now.hour || (hour == now.hour && minute < now.minute);
//   }
//   
//   bool get isAfterNow {
//     return !isBeforeNow;
//   }
//   
//   DayPeriod get period => hour < 12 ? DayPeriod.am : DayPeriod.pm;
//   
//   int get hourOfPeriod => hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
// }
