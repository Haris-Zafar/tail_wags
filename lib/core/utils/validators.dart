/// Shared form-field validators for `TextFormField.validator`. Used by
/// Login, Create Account, and Forgot Password — kept here (not per-feature)
/// because 3+ features need the same email/password rules.
class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? Function(String?) confirmPassword(String? Function() password) {
    return (value) {
      final v = value ?? '';
      if (v.isEmpty) return 'Please confirm your password';
      if (v != password()) return 'Passwords do not match';
      return null;
    };
  }
}
