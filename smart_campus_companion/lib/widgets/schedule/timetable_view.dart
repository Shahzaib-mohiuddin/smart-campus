import 'package:flutter/material.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';
import 'package:smart_campus_companion/theme/app_theme.dart';

class TimetableView extends StatelessWidget {
  final List<ClassSchedule> schedules;
  final ValueChanged<ClassSchedule>? onClassTap;
  final bool showCurrentTimeIndicator;
  
  // Time range for the timetable (in 24-hour format)
  static const int startHour = 8; // 8 AM
  static const int endHour = 20;   // 8 PM
  
  const TimetableView({
    super.key,
    required this.schedules,
    this.onClassTap,
    this.showCurrentTimeIndicator = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final timeColumnWidth = 60.0;
        final dayColumnWidth = (constraints.maxWidth - timeColumnWidth) / 5; // Mon-Fri
        final hourHeight = 80.0;
        
        return Stack(
          children: [
            // Grid background
            _buildGridBackground(context, timeColumnWidth, dayColumnWidth, hourHeight),
            
            // Class blocks
            ..._buildClassBlocks(context, timeColumnWidth, dayColumnWidth, hourHeight),
            
            // Current time indicator
            if (showCurrentTimeIndicator)
              _buildCurrentTimeIndicator(context, timeColumnWidth, dayColumnWidth, hourHeight),
          ],
        );
      },
    );
  }
  
  Widget _buildGridBackground(
    BuildContext context,
    double timeColumnWidth,
    double dayColumnWidth,
    double hourHeight,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      children: [
        // Header row with day names
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              // Empty cell for time column
              SizedBox(
                width: timeColumnWidth,
                child: Center(
                  child: Icon(
                    Icons.access_time,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              
              // Day headers (Mon-Fri)
              ...List.generate(5, (index) {
                final dayNumber = index + 1; // Monday = 1, Friday = 5
                final dayName = _getShortDayName(dayNumber);
                final isToday = _isToday(dayNumber);
                
                return Container(
                  width: dayColumnWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: colorScheme.outlineVariant),
                      bottom: BorderSide(
                        color: isToday ? colorScheme.primary : colorScheme.outlineVariant,
                        width: isToday ? 2 : 1,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isToday ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isToday)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        
        // Time slots
        Expanded(
          child: Stack(
            children: [
              // Hour markers and horizontal lines
              Column(
                children: List.generate(
                  (endHour - startHour) * 2 + 1, // Half-hour intervals
                  (index) {
                    final hour = startHour + (index ~/ 2);
                    final isHalfHour = index % 2 == 1;
                    final showHourLabel = !isHalfHour;
                    
                    return Container(
                      height: hourHeight / 2,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outlineVariant.withOpacity(0.5),
                            width: isHalfHour ? 0.5 : 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Time label
                          SizedBox(
                            width: timeColumnWidth,
                            child: showHourLabel
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8, top: 2),
                                    child: Text(
                                      '${hour == 12 ? 12 : hour % 12} ${hour < 12 ? 'AM' : 'PM'}',
                                      textAlign: TextAlign.end,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          
                          // Day columns
                          ...List.generate(5, (_) {
                            return Container(
                              width: dayColumnWidth,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: colorScheme.outlineVariant),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  List<Widget> _buildClassBlocks(
    BuildContext context,
    double timeColumnWidth,
    double dayColumnWidth,
    double hourHeight,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return schedules.map((schedule) {
      // Calculate position and size
      final left = timeColumnWidth + (schedule.dayOfWeek - 1) * dayColumnWidth;
      final top = _calculateTopPosition(schedule.startTime, hourHeight);
      final height = _calculateHeight(schedule.startTime, schedule.endTime, hourHeight);
      
      // Get color for the class
      final color = schedule.colorHex != null
          ? Color(int.parse('0xFF${schedule.colorHex!}'))
          : colorScheme.primary;
      
      return Positioned(
        left: left,
        top: top,
        width: dayColumnWidth,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Material(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onClassTap?.call(schedule),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.courseCode,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color.withOpacity(0.8),
                      ),
                      maxLines: 1,
                    ),
                    const Spacer(),
                    Text(
                      schedule.room,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
  
  Widget _buildCurrentTimeIndicator(
    BuildContext context,
    double timeColumnWidth,
    double dayColumnWidth,
    double hourHeight,
  ) {
    final now = DateTime.now();
    final currentDay = now.weekday; // 1 = Monday, 7 = Sunday
    
    // Only show indicator if current day is a weekday (1-5 = Monday-Friday)
    if (currentDay < 1 || currentDay > 5) return const SizedBox.shrink();
    
    final currentTime = TimeOfDay.fromDateTime(now);
    final currentHour = currentTime.hour;
    final currentMinute = currentTime.minute;
    
    // Only show if within the displayed hours
    if (currentHour < startHour || currentHour >= endHour) {
      return const SizedBox.shrink();
    }
    
    // Calculate position
    final top = ((currentHour - startHour) * 60 + currentMinute) * (hourHeight / 60);
    final left = timeColumnWidth + (currentDay - 1) * dayColumnWidth;
    
    return Positioned(
      left: left,
      top: top,
      width: dayColumnWidth,
      child: Container(
        height: 2,
        color: Theme.of(context).colorScheme.error,
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
  
  double _calculateTopPosition(TimeOfDay time, double hourHeight) {
    final hour = time.hour - startHour;
    final minute = time.minute;
    return (hour * 60 + minute) * (hourHeight / 60) + 40; // 40 = header height
  }
  
  double _calculateHeight(TimeOfDay startTime, TimeOfDay endTime, double hourHeight) {
    final startMinutes = (startTime.hour - startHour) * 60 + startTime.minute;
    final endMinutes = (endTime.hour - startHour) * 60 + endTime.minute;
    final durationMinutes = endMinutes - startMinutes;
    return durationMinutes * (hourHeight / 60);
  }
  
  String _getShortDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1: return 'MON';
      case 2: return 'TUE';
      case 3: return 'WED';
      case 4: return 'THU';
      case 5: return 'FRI';
      case 6: return 'SAT';
      case 7: return 'SUN';
      default: return '';
    }
  }
  
  bool _isToday(int dayOfWeek) {
    return dayOfWeek == DateTime.now().weekday;
  }
  
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')}';
  }
}
