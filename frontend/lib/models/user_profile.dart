// lib/models/user_profile.dart
class UserProfile {
  String id;
  String name;
  String email;
  String? college;
  String? course;
  String? yearOfStudy;
  String? avatarUrl;
  bool isFirstTime;
  bool hasCompletedAssessment;
  bool confizoneIntroCompleted;
  bool confizoneIntroSkipped;
  int confiPoints;
  double confiScore;
  int confiLevel;
  List<String> focusCategories;
  List<String> clickedActionIds;
  List<String> savedResourceIds;
  List<String> completedProgramIds;
  List<String> selectedCuriosities;
  DateTime? createdAt;

  UserProfile({
    this.id = '',
    this.name = '',
    this.email = '',
    this.college,
    this.course,
    this.yearOfStudy,
    this.avatarUrl,
    this.isFirstTime = true,
    this.hasCompletedAssessment = false,
    this.confizoneIntroCompleted = false,
    this.confizoneIntroSkipped = false,
    this.confiPoints = 0,
    this.confiScore = 0.0,
    this.confiLevel = 1,
    this.focusCategories = const [],
    this.clickedActionIds = const [],
    this.savedResourceIds = const [],
    this.completedProgramIds = const [],
    this.selectedCuriosities = const [],
    this.createdAt,
  });

  String get confiLevelName {
    const levels = [
      'Spark',
      'Seeker',
      'Explorer',
      'Aligner',
      'Builder',
      'Riser',
      'Achiever',
      'Connector',
      'Influencer',
      'Visionary',
      'Champion',
      'Legend',
    ];
    const subtitles = [
      'Just Beginning',
      'Finding Yourself',
      'Discovering Paths',
      'Finding Direction',
      'Taking Shape',
      'Gaining Momentum',
      'Making Impact',
      'Building Bridges',
      'Leading Others',
      'Defining Purpose',
      'Inspiring Change',
      'Leaving a Legacy',
    ];
    final idx = (confiLevel - 1).clamp(0, 11);
    return '${levels[idx]} (${subtitles[idx]})';
  }

  String get confiLevelShort {
    const levels = [
      'Spark', 'Seeker', 'Explorer', 'Aligner', 'Builder', 'Riser',
      'Achiever', 'Connector', 'Influencer', 'Visionary', 'Champion', 'Legend',
    ];
    final idx = (confiLevel - 1).clamp(0, 11);
    return levels[idx];
  }

  String get greeting {
    if (isFirstTime) {
      return name.isNotEmpty ? 'Hey ${name.split(' ').first}!' : 'Hey there!';
    } else {
      return name.isNotEmpty ? 'Welcome back, ${name.split(' ').first}!' : 'Welcome back!';
    }
  }
}
