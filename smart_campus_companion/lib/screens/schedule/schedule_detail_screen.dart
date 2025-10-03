import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus';
import 'package:smart_campus_companion/models/class_schedule.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final ClassSchedule schedule;
  
  const ScheduleDetailScreen({
    super.key,
    required this.schedule,
  });
  
  static Route route(RouteSettings settings) {
    final schedule = settings.arguments as ClassSchedule;
    return MaterialPageRoute(
      builder: (_) => ScheduleDetailScreen(schedule: schedule),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final cardColor = schedule.colorHex != null 
        ? Color(int.parse('0xFF${schedule.colorHex!}'))
        : colorScheme.primaryContainer;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _navigateToEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareClassDetails(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cardColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Color indicator
                  Container(
                    width: 8,
                    height: 60,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Class info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.courseCode,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          schedule.courseName,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Class Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Time
                    _buildDetailRow(
                      context,
                      icon: Icons.access_time_outlined,
                      title: 'Time',
                      value: '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                    ),
                    const Divider(),
                    
                    // Day
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      title: 'Day',
                      value: getDayName(schedule.dayOfWeek),
                    ),
                    const Divider(),
                    
                    // Instructor
                    _buildDetailRow(
                      context,
                      icon: Icons.person_outline,
                      title: 'Instructor',
                      value: schedule.instructor,
                      isLink: true,
                      onTap: () => _launchEmail(schedule.instructor),
                    ),
                    const Divider(),
                    
                    // Location
                    _buildDetailRow(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      value: schedule.room,
                      isLink: true,
                      onTap: () => _launchMaps(schedule.room),
                    ),
                    
                    // Recurring
                    if (schedule.isRecurring) ...[
                      const Divider(),
                      _buildDetailRow(
                        context,
                        icon: Icons.repeat_outlined,
                        title: 'Recurring',
                        value: 'Weekly',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Description
            if (schedule.description?.isNotEmpty == true) ...[
              const SizedBox(height: 16),
              Text(
                'About This Class',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                schedule.description!,
                style: textTheme.bodyLarge,
              ),
            ],
            
            // Quick Actions
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.alarm_add_outlined,
                  label: 'Set Reminder',
                  onTap: () => _setReminder(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.video_library_outlined,
                  label: 'Join Online',
                  onTap: () => _joinOnlineClass(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.assignment_outlined,
                  label: 'View Materials',
                  onTap: () => _viewMaterials(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.people_outline,
                  label: 'Class Group',
                  onTap: () => _openClassGroup(context),
                ),
              ],
            ),
            
            // Upcoming Assignments (Placeholder)
            const SizedBox(height: 32),
            Text(
              'Upcoming Assignments',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildAssignmentItem(
              context,
              title: 'Midterm Exam',
              dueDate: 'Due: Oct 15, 2023',
              isCompleted: false,
              color: Colors.red,
            ),
            _buildAssignmentItem(
              context,
              title: 'Project Submission',
              dueDate: 'Due: Oct 20, 2023',
              isCompleted: false,
              color: Colors.blue,
            ),
            _buildAssignmentItem(
              context,
              title: 'Weekly Quiz',
              dueDate: 'Completed',
              isCompleted: true,
              color: Colors.green,
            ),
            
            const SizedBox(height: 24),
            
            // Class Resources (Placeholder)
            Text(
              'Class Resources',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildResourceItem(
              context,
              icon: Icons.picture_as_pdf_outlined,
              title: 'Lecture 5 - Advanced Topics',
              subtitle: 'PDF • 2.4 MB',
            ),
            _buildResourceItem(
              context,
              icon: Icons.video_collection_outlined,
              title: 'Week 5 Recording',
              subtitle: 'Video • 45 min',
            ),
            _buildResourceItem(
              context,
              icon: Icons.link_outlined,
              title: 'Additional Resources',
              subtitle: 'Link • external-website.com',
            ),
          ],
        ),
      ),
      // Bottom button for quick actions
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToEdit(context),
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text('Edit Class'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                onPressed: () => _shareClassDetails(context),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                elevation: 0,
                child: const Icon(Icons.share_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: isLink ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isLink ? colorScheme.primary : colorScheme.onSurface,
                      fontWeight: isLink ? FontWeight.w500 : null,
                    ),
                  ),
                ],
              ),
            ),
            if (isLink)
              Icon(
                Icons.arrow_outward,
                size: 16,
                color: colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAssignmentItem(
    BuildContext context, {
    required String title,
    required String dueDate,
    required bool isCompleted,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.assignment_turned_in_outlined : Icons.assignment_outlined,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          dueDate,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isCompleted ? theme.colorScheme.onSurfaceVariant : color,
          ),
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle_outline, color: Colors.green)
            : const Icon(Icons.chevron_right),
        onTap: () {
          // Handle assignment tap
        },
      ),
    );
  }
  
  Widget _buildResourceItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.download_outlined),
        onTap: () {
          // Handle resource tap
        },
      ),
    );
  }
  
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }
  
  void _navigateToEdit(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/schedule/edit',
      arguments: schedule,
    );
  }
  
  String getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  Future<void> _launchEmail(String instructor) async {
    // Extract email from instructor name if possible, or use a default
    final email = '${instructor.split(' ').join('.').toLowerCase()}@university.edu';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Question about ${schedule.courseName}',
        'body': 'Dear ${instructor.split(' ')[0]},\n\n',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchMaps(String room) async {
    // Format the query for maps
    final query = Uri.encodeComponent('$room ${schedule.courseName}');
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    }
  }

  Future<void> _setReminder(BuildContext context) async {
    // Implementation for setting a reminder
    // This would typically use a package like flutter_local_notifications
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder set for this class')),
    );
  }

  Future<void> _joinOnlineClass(BuildContext context) async {
    // Implementation for joining an online class
    // This would typically launch a URL or open a meeting app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Joining online class...')),
    );
  }

  void _viewMaterials(BuildContext context) {
    // Implementation for viewing class materials
    // This would typically navigate to a materials screen
    Navigator.pushNamed(
      context,
      '/materials',
      arguments: {'courseId': schedule.id},
    );
  }

  void _openClassGroup(BuildContext context) {
    // Implementation for opening a class group
    // This would typically open a chat or forum
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening class group...')),
    );
  }

  Future<void> _shareClassDetails(BuildContext context) async {
    final String shareText = '''
📅 *When:* ${getDayName(schedule.dayOfWeek)}, ${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}
👨‍🏫 *Instructor:* ${schedule.instructor}
📍 *Location:* ${schedule.room}

Shared via Smart Campus Companion App
''';
    
    await Share.share(shareText);
  }
  
  void _joinOnlineClass(BuildContext context) {
    // Implement join online class logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Online Class'),
        content: const Text('This would open your default meeting app with the class link.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Launch meeting URL
            },
            child: const Text('JOIN'),
          ),
        ],
      ),
    );
  }
  
  void _viewMaterials(BuildContext context) {
    // Navigate to materials screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening course materials')),
    );
  }
  
  void _openClassGroup(BuildContext context) {
    // Open class group chat or forum
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening class group')),
    );
  }
}
