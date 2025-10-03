import 'package:flutter/material.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final ClassSchedule schedule;
  
  const ScheduleDetailScreen({
    Key? key,
    required this.schedule,
  }) : super(key: key);
  
  static Route route(RouteSettings settings) {
    final schedule = settings.arguments as ClassSchedule;
    return MaterialPageRoute(
      builder: (_) => ScheduleDetailScreen(schedule: schedule),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.schedule,
              label: 'Time',
              value: '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
            ),
            _buildInfoRow(
              context,
              icon: Icons.calendar_today,
              label: 'Day',
              value: _getDayName(schedule.dayOfWeek),
            ),
            if (schedule.instructor.isNotEmpty)
              _buildInfoRow(
                context,
                icon: Icons.person,
                label: 'Instructor',
                value: schedule.instructor,
              ),
            if (schedule.room.isNotEmpty)
              _buildInfoRow(
                context,
                icon: Icons.room,
                label: 'Location',
                value: schedule.room,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getDayName(int dayOfWeek) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[dayOfWeek % 7];
  }
}
