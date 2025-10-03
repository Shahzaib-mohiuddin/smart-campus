import 'package:intl/intl.dart';

class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    
    // Basic email validation pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+\$');
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }
  
  // Confirm password validator
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // Required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    
    return null;
  }
  
  // Phone number validator
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    
    // Basic phone number validation (adjust based on your requirements)
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Date validator
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    
    try {
      // Try to parse the date
      final dateFormat = DateFormat('MM/dd/yyyy');
      final date = dateFormat.parseStrict(value);
      
      // Check if the date is in the future (example validation)
      if (date.isAfter(DateTime.now())) {
        return 'Date cannot be in the future';
      }
      
      return null;
    } catch (e) {
      return 'Please enter a valid date (MM/DD/YYYY)';
    }
  }
  
  // Time validator
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a time';
    }
    
    try {
      // Try to parse the time
      final timeFormat = DateFormat('h:mm a');
      timeFormat.parseStrict(value);
      return null;
    } catch (e) {
      return 'Please enter a valid time (e.g., 2:30 PM)';
    }
  }
  
  // URL validator
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }
    
    // Basic URL validation
    final urlRegex = RegExp(
      r'^(https?:\/\/)?' // protocol
      r'(([a-zA-Z\d]([a-zA-Z\d-]*[a-zA-Z\d])*)\.)+[a-zA-Z]{2,}' // domain
      r'(\/[-a-zA-Z\d%_.~+]*)*' // path
      r'(\?[;&a-zA-Z\d%_.~+=-]*)?' // query string
      r'(\#[-a-zA-Z\d_]*)?$', // fragment locator
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  // Numeric validator
  static String? validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    
    return null;
  }
  
  // Positive number validator
  static String? validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    
    final number = double.tryParse(value);
    
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (number <= 0) {
      return 'Please enter a positive number';
    }
    
    return null;
  }
  
  // Minimum length validator
  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    if (value.length < minLength) {
      return 'Must be at least $minLength characters long';
    }
    
    return null;
  }
  
  // Maximum length validator
  static String? validateMaxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Must be at most $maxLength characters long';
    }
    
    return null;
  }
  
  // Exact length validator
  static String? validateExactLength(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    if (value.length != length) {
      return 'Must be exactly $length characters long';
    }
    
    return null;
  }
  
  // Pattern validator
  static String? validatePattern(String? value, Pattern pattern, String errorMessage) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    if (!RegExp(pattern as String).hasMatch(value)) {
      return errorMessage;
    }
    
    return null;
  }
  
  // Validate if value is between min and max (inclusive)
  static String? validateRange(String? value, {num? min, num? max}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    final number = num.tryParse(value);
    
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (min != null && number < min) {
      return 'Must be at least $min';
    }
    
    if (max != null && number > max) {
      return 'Must be at most $max';
    }
    
    return null;
  }
  
  // Validate if value is a valid date in the past
  static String? validatePastDate(String? value, {String? format}) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    
    try {
      final dateFormat = format != null ? DateFormat(format) : DateFormat('MM/dd/yyyy');
      final date = dateFormat.parseStrict(value);
      
      if (date.isAfter(DateTime.now())) {
        return 'Date must be in the past';
      }
      
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }
  
  // Validate if value is a valid date in the future
  static String? validateFutureDate(String? value, {String? format}) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    
    try {
      final dateFormat = format != null ? DateFormat(format) : DateFormat('MM/dd/yyyy');
      final date = dateFormat.parseStrict(value);
      
      if (date.isBefore(DateTime.now())) {
        return 'Date must be in the future';
      }
      
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }
  
  // Validate if value is a valid time in the future
  static String? validateFutureTime(String? value, {DateTime? referenceTime}) {
    if (value == null || value.isEmpty) {
      return 'Please select a time';
    }
    
    try {
      final timeFormat = DateFormat('h:mm a');
      final time = timeFormat.parseStrict(value);
      
      final now = referenceTime ?? DateTime.now();
      final timeToday = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      
      if (timeToday.isBefore(now)) {
        return 'Time must be in the future';
      }
      
      return null;
    } catch (e) {
      return 'Please enter a valid time';
    }
  }
}
