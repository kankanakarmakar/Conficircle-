// lib/services/analytics_service.dart
// Tracks user interactions for the recommendation engine

class AnalyticsEvent {
  final String eventName;
  final String? entityId;
  final String? entityType;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.eventName,
    this.entityId,
    this.entityType,
    this.properties = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'event': eventName,
    'entity_id': entityId,
    'entity_type': entityType,
    'properties': properties,
    'timestamp': timestamp.toIso8601String(),
  };
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final List<AnalyticsEvent> _events = [];

  List<AnalyticsEvent> get events => List.unmodifiable(_events);

  /// Track when a user views an action card
  void trackActionView(String actionId, String category) {
    _track(AnalyticsEvent(
      eventName: 'action_view',
      entityId: actionId,
      entityType: 'action',
      properties: {'category': category},
    ));
  }

  /// Track when a user clicks on an action
  void trackActionClick(String actionId, String category) {
    _track(AnalyticsEvent(
      eventName: 'action_click',
      entityId: actionId,
      entityType: 'action',
      properties: {'category': category},
    ));
  }

  /// Track when a user saves a resource
  void trackResourceSave(String resourceId, String type) {
    _track(AnalyticsEvent(
      eventName: 'resource_save',
      entityId: resourceId,
      entityType: 'resource',
      properties: {'type': type},
    ));
  }

  /// Track when a user views a resource detail
  void trackResourceView(String resourceId, String category) {
    _track(AnalyticsEvent(
      eventName: 'resource_view',
      entityId: resourceId,
      entityType: 'resource',
      properties: {'category': category},
    ));
  }

  /// Track when a user joins a group
  void trackGroupJoin(String groupId) {
    _track(AnalyticsEvent(
      eventName: 'group_join',
      entityId: groupId,
      entityType: 'group',
    ));
  }

  /// Track when a user completes an assessment
  void trackAssessmentComplete(double score, int level) {
    _track(AnalyticsEvent(
      eventName: 'assessment_complete',
      properties: {'score': score, 'level': level},
    ));
  }

  /// Track screen view
  void trackScreenView(String screenName) {
    _track(AnalyticsEvent(
      eventName: 'screen_view',
      properties: {'screen': screenName},
    ));
  }

  /// Track when a user starts a program
  void trackProgramStart(String programId, String type) {
    _track(AnalyticsEvent(
      eventName: 'program_start',
      entityId: programId,
      entityType: 'program',
      properties: {'type': type},
    ));
  }

  /// Get category engagement scores (for recommendations)
  Map<String, int> getCategoryEngagement() {
    final Map<String, int> engagement = {};
    for (final event in _events) {
      if (event.properties.containsKey('category')) {
        final cat = event.properties['category'] as String;
        engagement[cat] = (engagement[cat] ?? 0) + 1;
      }
    }
    return engagement;
  }

  /// Most engaged category
  String? get topCategory {
    final eng = getCategoryEngagement();
    if (eng.isEmpty) return null;
    return eng.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  void _track(AnalyticsEvent event) {
    _events.add(event);
    // In production: send to backend / Firebase Analytics
    // debugPrint('[Analytics] ${event.eventName}: ${event.properties}');
  }

  void clearEvents() => _events.clear();
}
