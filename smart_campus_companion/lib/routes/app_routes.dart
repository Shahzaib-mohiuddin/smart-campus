import 'package:flutter/material.dart';
import 'package:smart_campus_companion/models/class_schedule.dart';
import 'package:smart_campus_companion/screens/auth/login_screen.dart';
import 'package:smart_campus_companion/screens/auth/profile_setup_screen.dart';
import 'package:smart_campus_companion/screens/auth/register_screen.dart';
import 'package:smart_campus_companion/screens/auth/splash_screen.dart';
import 'package:smart_campus_companion/screens/home/dashboard_screen.dart';
import 'package:smart_campus_companion/screens/schedule/schedule_detail_screen.dart';
import 'package:smart_campus_companion/screens/schedule/schedule_form_screen.dart';
import 'package:smart_campus_companion/screens/schedule/weekly_schedule_screen.dart';

/// A class that defines all the named routes used in the application.
/// This helps in maintaining consistent route names throughout the app.
class AppRoutes {
  /// Route for the splash screen
  static const String splash = '/';
  
  /// Route for the login screen
  static const String login = '/login';
  
  /// Route for the registration screen
  static const String register = '/register';
  
  /// Route for the profile setup screen
  static const String profileSetup = '/profile-setup';
  
  /// Route for the home/dashboard screen
  static const String home = '/home';
  
  /// Schedule related routes
  static const String schedule = '/schedule';
  
  /// Route for adding a new schedule
  static const String addSchedule = '/schedule/add';
  
  /// Route for editing an existing schedule
  static const String editSchedule = '/schedule/edit';
  
  /// Route for viewing schedule details
  static const String scheduleDetail = '/schedule/detail';
  
  /// Generates a route based on the given [settings].
  /// 
  /// Returns a [Route] that corresponds to the provided route name.
  /// If the route name is not recognized, returns a route to a 'not found' screen.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const SplashScreen(),
        );
      case login:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const LoginScreen(),
        );
      case register:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const RegisterScreen(),
        );
      case profileSetup:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const ProfileSetupScreen(),
        );
      case home:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const DashboardScreen(),
        );
        
      // Schedule Routes
      case schedule:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const WeeklyScheduleScreen(),
        );
        
      case addSchedule:
        final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => ScheduleFormScreen(
            initialDayOfWeek: args?['initialDay'] as int?,
          ),
        );
        
      case editSchedule:
        final ClassSchedule schedule = settings.arguments as ClassSchedule;
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => ScheduleFormScreen(schedule: schedule),
        );
        
      case scheduleDetail:
        final ClassSchedule schedule = settings.arguments as ClassSchedule;
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => ScheduleDetailScreen(schedule: schedule),
        );
        
      default:
        return MaterialPageRoute<Scaffold>(
          builder: (BuildContext _) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  static void pushNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
  
  static void pushReplacementNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }
  
  static void pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }
  
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }
  
  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil((route) => route.settings.name == routeName);
  }
}
