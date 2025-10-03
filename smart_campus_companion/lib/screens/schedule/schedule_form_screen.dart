import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';
import 'package:smart_campus_companion/providers/class_schedule_provider.dart';
import 'package:smart_campus_companion/providers/auth_provider.dart';
import 'package:smart_campus_companion/utils/constants.dart';
import 'package:smart_campus_companion/theme/app_theme.dart';
import 'package:smart_campus_companion/widgets/custom_button.dart';
import 'package:smart_campus_companion/widgets/custom_text_field.dart';
import 'package:smart_campus_companion/utils/validators.dart';

class ScheduleFormScreen extends StatefulWidget {
  static const routeName = '/schedule/form';
  
  final ClassSchedule? schedule;
  final int? initialDayOfWeek;
  
  const ScheduleFormScreen({
    super.key,
    this.schedule,
    this.initialDayOfWeek,
  });
  
  static Route route(RouteSettings settings) {
    final args = settings.arguments as dynamic;
    return MaterialPageRoute(
      builder: (_) => ScheduleFormScreen(
        schedule: args is ClassSchedule ? args : null,
        initialDayOfWeek: args is Map ? args['initialDay'] as int? : null,
      ),
    );
  }

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late TextEditingController _courseCodeController;
  late TextEditingController _courseNameController;
  late TextEditingController _instructorController;
  late TextEditingController _roomController;
  late TextEditingController _descriptionController;
  
  // Form values
  late int _dayOfWeek;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  String? _colorHex;
  bool _isRecurring = true;
  
  // Available days of the week
  final List<Map<String, dynamic>> _days = [
    {'value': 1, 'label': 'Monday'},
    {'value': 2, 'label': 'Tuesday'},
    {'value': 3, 'label': 'Wednesday'},
    {'value': 4, 'label': 'Thursday'},
    {'value': 5, 'label': 'Friday'},
    {'value': 6, 'label': 'Saturday'},
    {'value': 7, 'label': 'Sunday'},
  ];
  
  // Available colors for the schedule
  final List<Color> _colors = [
    const Color(0xFF4285F4), // Blue
    const Color(0xFFEA4335), // Red
    const Color(0xFFFBBC05), // Yellow
    const Color(0xFF34A853), // Green
    const Color(0xFF673AB7), // Purple
    const Color(0xFFFF9800), // Orange
    const Color(0xFF9C27B0), // Deep Purple
    const Color(0xFF00BCD4), // Cyan
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Initialize form with existing schedule data if in edit mode
    final schedule = widget.schedule;
    if (schedule != null) {
      _courseCodeController = TextEditingController(text: schedule.courseCode);
      _courseNameController = TextEditingController(text: schedule.courseName);
      _instructorController = TextEditingController(text: schedule.instructor);
      _roomController = TextEditingController(text: schedule.room);
      _descriptionController = TextEditingController(text: schedule.description ?? '');
      _dayOfWeek = schedule.dayOfWeek;
      _startTime = schedule.startTime;
      _endTime = schedule.endTime;
      _colorHex = schedule.colorHex;
      _isRecurring = schedule.isRecurring;
    } else {
      _courseCodeController = TextEditingController();
      _courseNameController = TextEditingController();
      _instructorController = TextEditingController();
      _roomController = TextEditingController();
      _descriptionController = TextEditingController();
      _dayOfWeek = widget.initialDayOfWeek ?? DateTime.now().weekday;
      _colorHex = _colors.first.value.toRadixString(16).substring(2);
    }
  }
  
  @override
  void dispose() {
    _courseCodeController.dispose();
    _courseNameController.dispose();
    _instructorController.dispose();
    _roomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditMode = widget.schedule != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Class' : 'Add New Class'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Course Code
            CustomTextField(
              controller: _courseCodeController,
              label: 'Course Code',
              hint: 'e.g., CS-101',
              prefixIcon: Icon(Icons.class_outlined),
              validator: (value) => Validators.validateRequired(value, 'course code'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            
            // Course Name
            CustomTextField(
              controller: _courseNameController,
              label: 'Course Name',
              hint: 'e.g., Introduction to Computer Science',
              prefixIcon: Icon(Icons.school_outlined),
              validator: (value) => Validators.validateRequired(value, 'course name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            
            // Instructor
            CustomTextField(
              controller: _instructorController,
              label: 'Instructor',
              hint: 'e.g., Dr. John Smith',
              prefixIcon: Icon(Icons.person_outline),
              validator: (value) => Validators.validateRequired(value, 'instructor name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            
            // Room
            CustomTextField(
              controller: _roomController,
              label: 'Room',
              hint: 'e.g., A-101',
              prefixIcon: Icon(Icons.meeting_room_outlined),
              validator: (value) => Validators.validateRequired(value, 'room number'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),
            
            // Day of Week
            Text(
              'Day of Week',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _days.map((day) {
                final isSelected = _dayOfWeek == day['value'];
                return ChoiceChip(
                  label: Text(day['label'] as String),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _dayOfWeek = day['value'] as int;
                      });
                    }
                  },
                  selectedColor: colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected ? colorScheme.onPrimaryContainer : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Time Picker Row
            Row(
              children: [
                // Start Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _selectTime(context, isStartTime: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.surface,
                          foregroundColor: colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // End Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _selectTime(context, isStartTime: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.surface,
                          foregroundColor: colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Color Picker
            Text(
              'Color',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  final isSelected = _colorHex == color.value.toRadixString(16).substring(2);
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _colorHex = color.value.toRadixString(16).substring(2);
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: colorScheme.primary,
                                width: 3,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Recurring Toggle
            Row(
              children: [
                Switch(
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                  activeColor: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recurring',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                const Tooltip(
                  message: 'If enabled, this class will repeat every week',
                  child: Icon(Icons.help_outline, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            CustomTextField(
              controller: _descriptionController,
              label: 'Description (Optional)',
              hint: 'Add any additional notes about this class',
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32),
            
            // Save Button
            Consumer<ClassScheduleProvider>(
              builder: (context, provider, _) {
                return CustomButton(
                  onPressed: provider.isLoading ? null : _saveSchedule,
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(isEditMode ? 'UPDATE CLASS' : 'ADD CLASS'),
                );
              },
            ),
            
            if (isEditMode) ...[
              const SizedBox(height: 16),
              // Delete Button
              OutlinedButton(
                onPressed: _showDeleteConfirmation,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: colorScheme.error),
                ),
                child: Text(
                  'DELETE CLASS',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Future<void> _selectTime(BuildContext context, {required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // If end time is before start time, update it
          if (_endTime.hour < picked.hour || (_endTime.hour == picked.hour && _endTime.minute <= picked.minute)) {
            _endTime = TimeOfDay(
              hour: picked.hour + 1,
              minute: picked.minute,
            );
          }
        } else {
          _endTime = picked;
          // If start time is after end time, update it
          if (_startTime.hour > picked.hour || (_startTime.hour == picked.hour && _startTime.minute >= picked.minute)) {
            _startTime = TimeOfDay(
              hour: picked.hour - 1 >= 0 ? picked.hour - 1 : 0,
              minute: picked.minute,
            );
          }
        }
      });
    }
  }
  
  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) return;
    
    final userId = context.read<AuthProvider>().user?.uid;
    if (userId == null) return;
    
    final provider = context.read<ClassScheduleProvider>();
    
    final schedule = ClassSchedule(
      id: widget.schedule?.id ?? '',
      courseCode: _courseCodeController.text.trim(),
      courseName: _courseNameController.text.trim(),
      instructor: _instructorController.text.trim(),
      room: _roomController.text.trim(),
      dayOfWeek: _dayOfWeek,
      startTime: _startTime,
      endTime: _endTime,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      colorHex: _colorHex,
      createdBy: userId,
      isRecurring: _isRecurring,
      // Keep the original created date if editing
      createdAt: widget.schedule?.createdAt,
      updatedAt: widget.schedule?.updatedAt,
    );
    
    final success = widget.schedule == null
        ? await provider.addSchedule(schedule)
        : await provider.updateSchedule(schedule);
    
    if (success && mounted) {
      Navigator.pop(context);
    } else if (provider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!)),
      );
    }
  }
  
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content: const Text('Are you sure you want to delete this class? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteSchedule();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _deleteSchedule() async {
    if (widget.schedule == null) return;
    
    final provider = context.read<ClassScheduleProvider>();
    final success = await provider.deleteSchedule(widget.schedule!.id);
    
    if (success && mounted) {
      Navigator.pop(context);
    } else if (provider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!)),
      );
    }
  }
}
