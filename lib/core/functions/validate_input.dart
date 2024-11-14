import 'package:get/get_utils/src/get_utils/get_utils.dart';

inputValidate(String value, String type, int min, int max) {
  // SQL Injection and Command Injection patterns
  if (RegExp(r'''(SELECT|DROP|INSERT|DELETE|UPDATE|;|'|--|OR|AND|=|"|\*|\$|\+|%)''').hasMatch(value.toUpperCase())) {
    return "Invalid input: potentially harmful characters detected";
  }
  // XSS patterns (e.g., script tags, img tags, etc.)
  if (RegExp(r'(<|>|script|img|alert|onerror|onload|iframe|src|javascript)').hasMatch(value.toLowerCase())) {
    return "Invalid input: potentially harmful XSS characters detected";
  }
  // File Inclusion and Path Traversal patterns
  if (RegExp(r'(\.\.|\/|\\|etc|passwd|~|%2e%2e|%2f)').hasMatch(value)) {
    return "Invalid input: potentially harmful file inclusion/path traversal detected";
  }
  if (!GetUtils.isLengthBetween(value, min, max)) {
    return "It should be between $min and $max";
  }
  if (type == "email") {
    if (!GetUtils.isEmail(value)) {
      return "not valid email";
    }
    // Email domain check (allow more domains or make it configurable)
    if (!(value.endsWith("@gmail.com") || value.endsWith("@hotmail.com") || value.endsWith("@yahoo.com"))) {
      return "Email must be from a trusted domain (e.g., Gmail, Hotmail, Yahoo)";
    }
  }
  if (type == "name/email") {
    if (!GetUtils.isEmail(value) && !GetUtils.isUsername(value)) {
      return "not valid email or username";
    }
  }
  if (type == "password") {
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
      return "Password must contain uppercase, lowercase, number, and special character";
    }
  }
  if (type == "user name") {
    if (!GetUtils.isUsername(value)) {
      return "not valid Username";
    }
  }
  return null;
}
