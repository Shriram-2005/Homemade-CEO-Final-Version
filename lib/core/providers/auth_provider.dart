import 'package:flutter/foundation.dart';

/// Singleton that holds the currently authenticated user's identity.
/// Populated by OtpAuthScreen (phone) or AdminLoginScreen (email).
/// Cleared on sign-out.
class AuthProvider extends ChangeNotifier {
  static final AuthProvider _instance = AuthProvider._internal();
  factory AuthProvider() => _instance;
  AuthProvider._internal();

  String _phone = '';
  String _email = '';
  String _role = ''; // 'buyer' | 'seller' | 'admin'

  String get phone => _phone;
  String get email => _email;
  String get role => _role;

  /// Display identity shown in the nav bar
  String get displayIdentity {
    if (_role == 'admin') return _email;
    if (_phone.isNotEmpty) return '+91 $_phone';
    return '';
  }

  void setPhone(String phone, String role) {
    _phone = phone;
    _role = role;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    _role = 'admin';
    notifyListeners();
  }

  void signOut() {
    _phone = '';
    _email = '';
    _role = '';
    notifyListeners();
  }
}
