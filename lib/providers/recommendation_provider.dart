// lib/providers/recommendation_provider.dart
import 'package:flutter/foundation.dart';
import '../models/action_item.dart';
import '../data/mock_actions.dart';

class RecommendationProvider extends ChangeNotifier {
  List<ActionItem> _visibleActions = [];
  List<String> _shownActionIds = [];
  bool _exploreMoreVisible = false;

  List<ActionItem> get visibleActions => _visibleActions;
  bool get exploreMoreVisible => _exploreMoreVisible;

  void initialize() {
    _visibleActions = getInitialSixActions();
    _shownActionIds = _visibleActions.map((a) => a.id).toList();
  }

  void loadExploreMore() {
    final more = getExploreMoreActions(_shownActionIds);
    _visibleActions = [..._visibleActions, ...more];
    _shownActionIds = _visibleActions.map((a) => a.id).toList();
    _exploreMoreVisible = true;
    notifyListeners();
  }

  void recordActionClick(String actionId) {
    // In a real app, this would send to analytics and update recommendation weights
    debugPrint('Action clicked: $actionId');
  }
}
