// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _profile = UserProfile(
    id: 'demo-user',
    name: 'Anaya',
    isFirstTime: true,
    confiScore: 0,
    confiLevel: 1,
    focusCategories: ['Career Clarity', 'Confidence & Self-Worth', 'Communication & Expression'],
  );

  UserProfile get profile => _profile;

  bool get isFirstTime => _profile.isFirstTime;
  bool get hasCompletedAssessment => _profile.hasCompletedAssessment;
  bool get confizoneIntroCompleted => _profile.confizoneIntroCompleted;
  bool get confizoneIntroSkipped => _profile.confizoneIntroSkipped;

  void updateProfile({
    String? name,
    String? college,
    String? course,
    String? yearOfStudy,
    List<String>? selectedCuriosities,
    List<String>? focusCategories,
  }) {
    if (name != null) _profile.name = name;
    if (college != null) _profile.college = college;
    if (course != null) _profile.course = course;
    if (yearOfStudy != null) _profile.yearOfStudy = yearOfStudy;
    if (selectedCuriosities != null) _profile.selectedCuriosities = selectedCuriosities;
    if (focusCategories != null) _profile.focusCategories = focusCategories;
    notifyListeners();
  }

  void completeOnboarding() {
    // NOTE: isFirstTime stays true until the user completes the assessment.
    // This ensures post-onboarding users land on FirstTimeHomeScreen, not MainShell.
    notifyListeners();
  }

  void completeAssessment({double score = 57.0, int level = 5}) {
    _profile.hasCompletedAssessment = true;
    _profile.confiScore = score;
    _profile.confiLevel = level;
    _profile.isFirstTime = false;
    notifyListeners();
  }

  void setConfizoneIntroCompleted() {
    _profile.confizoneIntroCompleted = true;
    notifyListeners();
  }

  void setConfizoneIntroSkipped(bool value) {
    _profile.confizoneIntroSkipped = value;
    notifyListeners();
  }

  void addClickedAction(String actionId) {
    if (!_profile.clickedActionIds.contains(actionId)) {
      _profile.clickedActionIds = [..._profile.clickedActionIds, actionId];
      // Increase confi points for engagement
      _profile.confiPoints += 5;
      notifyListeners();
    }
  }

  void toggleSaveResource(String resourceId) {
    final saved = List<String>.from(_profile.savedResourceIds);
    if (saved.contains(resourceId)) {
      saved.remove(resourceId);
    } else {
      saved.add(resourceId);
      _profile.confiPoints += 10;
    }
    _profile.savedResourceIds = saved;
    notifyListeners();
  }

  void addConfiPoints(int points) {
    _profile.confiPoints += points;
    notifyListeners();
  }

  void setExistingStudentDemo() {
    _profile = UserProfile(
      id: 'demo-user',
      name: 'Anaya',
      isFirstTime: false,
      hasCompletedAssessment: true,
      confiScore: 57,
      confiLevel: 5,
      confiPoints: 340,
      focusCategories: ['Career Clarity', 'Confidence & Self-Worth', 'Communication & Expression'],
      clickedActionIds: ['A001', 'A006', 'A022'],
      confizoneIntroCompleted: true,
    );
    notifyListeners();
  }

  /// Resets the profile to a fresh first-time user state.
  /// Useful for dev/demo toggling between user experiences.
  void resetToFirstTime() {
    _profile = UserProfile(
      id: 'demo-user',
      name: 'Anaya',
      isFirstTime: true,
      confiScore: 0,
      confiLevel: 1,
      focusCategories: ['Career Clarity', 'Confidence & Self-Worth', 'Communication & Expression'],
    );
    notifyListeners();
  }
}
