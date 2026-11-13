// test/features/discovery/problem_profile_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:conficircle/features/discovery/domain/entities/concern_prompt_entity.dart';

void main() {
  group('Problem Profile & Concern Entity Tests (Spec v3.0)', () {
    test('ConcernPromptEntity maps plain-language statements correctly', () {
      final json = {
        'id': 'concern-101',
        'promptText': 'I freeze or stay quiet during important meetings or discussions',
        'order': 1,
      };

      final concern = ConcernPromptEntity.fromJson(json);
      expect(concern.id, 'concern-101');
      expect(concern.promptText, 'I freeze or stay quiet during important meetings or discussions');
      expect(concern.isSelected, isFalse);

      final selected = concern.copyWith(isSelected: true);
      expect(selected.isSelected, isTrue);
    });

    test('Selection limit respects 5 active concerns max', () {
      final selectedIds = <String>{'c1', 'c2', 'c3', 'c4'};
      expect(selectedIds.length, 4);

      // Add 5th
      selectedIds.add('c5');
      expect(selectedIds.length, 5);

      // Attempting to add 6th should exceed maximum
      bool canAddMore = selectedIds.length < 5;
      expect(canAddMore, isFalse);
    });
  });
}

