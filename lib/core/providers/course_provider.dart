import 'package:flutter/foundation.dart';

/// Tracks LMS module completion state for the Seller.
/// In production this would sync with a backend.
/// For now it uses in-memory state with a predefined structure matching MockData.lmsModules.
class CourseProvider extends ChangeNotifier {
  static final CourseProvider _instance = CourseProvider._internal();
  factory CourseProvider() => _instance;
  CourseProvider._internal();

  // Module statuses: 'Completed' | 'Unlocked' | 'Locked'
  // Initial state: only the first module is unlocked for a fresh seller.
  // Modules unlock sequentially as each one is completed.
  final List<Map<String, dynamic>> _modules = [
    {'id': 'mod_1', 'title': 'Business Fundamentals (ബിസിനസ് അടിസ്ഥാനങ്ങൾ)', 'duration': 15, 'status': 'Unlocked'},
    {'id': 'mod_2', 'title': 'Product Photography (ഉൽപ്പന്ന ഫോട്ടോഗ്രാഫി)', 'duration': 12, 'status': 'Locked'},
    {'id': 'mod_3', 'title': 'Pricing & Margins (വിലനിർണ്ണയവും ലാഭവും)', 'duration': 18, 'status': 'Locked'},
    {'id': 'mod_4', 'title': 'Packaging & Shipping (പാക്കേജിംഗും ഷിപ്പിംഗും)', 'duration': 10, 'status': 'Locked'},
    {'id': 'mod_5', 'title': 'Customer Service (ഉപഭോക്തൃ സേവനം)', 'duration': 14, 'status': 'Locked'},
  ];


  /// Developer-only bypass code (testing purposes only)
  static const String _devBypassCode = 'HOMECEO_DEV';

  List<Map<String, dynamic>> get modules => List.unmodifiable(_modules);

  int get completedCount => _modules.where((m) => m['status'] == 'Completed').length;
  int get totalCount => _modules.length;
  double get progress => completedCount / totalCount;

  bool get allCoursesCompleted => completedCount == totalCount;

  /// Returns true if seller can access selling features (Products, Payments)
  bool get canSell => allCoursesCompleted;

  /// Mark a specific module as completed and unlock the next one
  void completeModule(String moduleId) {
    final idx = _modules.indexWhere((m) => m['id'] == moduleId);
    if (idx == -1) return;
    if (_modules[idx]['status'] == 'Completed') return; // already done

    _modules[idx] = Map<String, dynamic>.from(_modules[idx])..['status'] = 'Completed';

    // Unlock the next module
    if (idx + 1 < _modules.length) {
      if (_modules[idx + 1]['status'] == 'Locked') {
        _modules[idx + 1] = Map<String, dynamic>.from(_modules[idx + 1])..['status'] = 'Unlocked';
      }
    }
    notifyListeners();
  }

  /// DEV ONLY: Enter the bypass code to complete all modules instantly
  /// Returns true if the code was valid
  bool applyDevBypass(String code) {
    if (code.trim() == _devBypassCode) {
      for (int i = 0; i < _modules.length; i++) {
        _modules[i] = Map<String, dynamic>.from(_modules[i])..['status'] = 'Completed';
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Reset all modules back to initial state (for testing)
  void resetAll() {
    for (int i = 0; i < _modules.length; i++) {
      _modules[i] = Map<String, dynamic>.from(_modules[i])
        ..['status'] = i == 0 ? 'Unlocked' : 'Locked';
    }
    notifyListeners();
  }
}
