// lib/providers/analytics_provider.dart
import 'package:flutter/foundation.dart';
import '../services/analytics_service.dart';
import '../services/recommendation_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsService _analytics = AnalyticsService();
  final RecommendationService _recommendations = RecommendationService();

  AnalyticsService get analytics => _analytics;
  RecommendationService get recommendations => _recommendations;

  // ──────────────────────────────────────────
  // Action tracking
  // ──────────────────────────────────────────

  void trackActionClick(String actionId, String category) {
    _analytics.trackActionClick(actionId, category);
    _recommendations.recordActionClick(actionId, category);
    notifyListeners();
  }

  void trackActionExplore(String actionId, String category) {
    _analytics.trackActionView(actionId, category);
    _recommendations.recordActionExplore(actionId, category);
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // Resource tracking
  // ──────────────────────────────────────────

  void trackResourceSave(String resourceId, String category) {
    _analytics.trackResourceSave(resourceId, category);
    _recommendations.recordResourceSave(category);
    notifyListeners();
  }

  void trackResourceView(String resourceId, String category) {
    _analytics.trackResourceView(resourceId, category);
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // Group tracking
  // ──────────────────────────────────────────

  void trackGroupJoin(String groupId) {
    _analytics.trackGroupJoin(groupId);
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // Assessment tracking
  // ──────────────────────────────────────────

  void trackAssessmentComplete(double score, int level) {
    _analytics.trackAssessmentComplete(score, level);
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // Onboarding signals
  // ──────────────────────────────────────────

  void setFocusCategories(List<String> categories) {
    _recommendations.recordFocusCategories(categories);
    notifyListeners();
  }

  // ──────────────────────────────────────────
  // Screen tracking
  // ──────────────────────────────────────────

  void trackScreen(String screenName) {
    _analytics.trackScreenView(screenName);
  }

  // ──────────────────────────────────────────
  // Getters
  // ──────────────────────────────────────────

  String? get topCategory => _recommendations.topCategory;
  bool get hasPersonalisationData => _recommendations.hasPersonalisationData;
  Map<String, int> get categoryEngagement => _analytics.getCategoryEngagement();

  void reset() {
    _analytics.clearEvents();
    _recommendations.reset();
    notifyListeners();
  }
}
