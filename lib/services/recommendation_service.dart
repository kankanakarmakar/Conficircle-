// lib/services/recommendation_service.dart
// Netflix-style recommendation engine that learns from student behavior

import '../models/action_item.dart';
import '../models/program.dart';
import '../models/resource.dart';
import '../data/mock_actions.dart';
import '../data/mock_programs.dart';
import '../data/mock_resources.dart';

class RecommendationService {
  static final RecommendationService _instance = RecommendationService._internal();
  factory RecommendationService() => _instance;
  RecommendationService._internal();

  /// Weights for each category based on user engagement (category → score 0–1)
  final Map<String, double> _categoryWeights = {};

  /// IDs the user has already interacted with
  final Set<String> _seenActionIds = {};
  final Set<String> _seenResourceIds = {};

  // ──────────────────────────────────────────
  // Recording signals
  // ──────────────────────────────────────────

  void recordActionClick(String actionId, String category) {
    _seenActionIds.add(actionId);
    _boostCategory(category, 0.3);
  }

  void recordActionExplore(String actionId, String category) {
    _seenActionIds.add(actionId);
    _boostCategory(category, 0.5);
  }

  void recordResourceSave(String category) {
    _boostCategory(category, 0.4);
  }

  void recordAssessmentResult(Map<String, double> categoryScores) {
    // Boost categories with lower scores (needs more attention)
    for (final entry in categoryScores.entries) {
      final needFactor = (100 - entry.value) / 100;
      _boostCategory(entry.key, needFactor * 0.6);
    }
  }

  void recordFocusCategories(List<String> categories) {
    for (final cat in categories) {
      _boostCategory(cat, 0.8);
    }
  }

  // ──────────────────────────────────────────
  // Getting recommendations
  // ──────────────────────────────────────────

  /// Returns top N recommended actions for this user
  List<ActionItem> getRecommendedActions({int count = 6, List<String> excludeIds = const []}) {
    final all = allActions.where((a) =>
      !_seenActionIds.contains(a.id) && !excludeIds.contains(a.id),
    ).toList();

    // Score each action by category weight
    all.sort((a, b) {
      final scoreA = _categoryWeights[a.category] ?? 0;
      final scoreB = _categoryWeights[b.category] ?? 0;
      return scoreB.compareTo(scoreA);
    });

    return all.take(count).toList();
  }

  /// Returns "Because you explored..." actions in a specific category
  List<ActionItem> getBecauseYouExplored(String category, {int count = 4}) {
    return allActions
        .where((a) => a.category == category && !_seenActionIds.contains(a.id))
        .take(count)
        .toList();
  }

  /// Returns recommended programs based on focus categories
  List<Program> getRecommendedPrograms({int count = 4}) {
    final all = allPrograms;
    if (_categoryWeights.isEmpty) return all.take(count).toList();

    final sorted = List<Program>.from(all);
    sorted.sort((a, b) {
      final scoreA = _categoryWeights[a.category] ?? 0;
      final scoreB = _categoryWeights[b.category] ?? 0;
      return scoreB.compareTo(scoreA);
    });

    return sorted.take(count).toList();
  }

  /// Returns recommended resources
  List<Resource> getRecommendedResources({int count = 4}) {
    final all = allResources.where((r) => !_seenResourceIds.contains(r.id)).toList();
    if (_categoryWeights.isEmpty) return all.take(count).toList();

    all.sort((a, b) {
      final scoreA = _categoryWeights[a.category] ?? 0;
      final scoreB = _categoryWeights[b.category] ?? 0;
      return scoreB.compareTo(scoreA);
    });

    return all.take(count).toList();
  }

  /// Top category the user is most interested in
  String? get topCategory {
    if (_categoryWeights.isEmpty) return null;
    return _categoryWeights.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Whether we have enough signals to personalise
  bool get hasPersonalisationData => _categoryWeights.isNotEmpty;

  // ──────────────────────────────────────────
  // Internal helpers
  // ──────────────────────────────────────────

  void _boostCategory(String category, double amount) {
    _categoryWeights[category] = ((_categoryWeights[category] ?? 0) + amount).clamp(0.0, 1.0);
  }

  void reset() {
    _categoryWeights.clear();
    _seenActionIds.clear();
    _seenResourceIds.clear();
  }
}
