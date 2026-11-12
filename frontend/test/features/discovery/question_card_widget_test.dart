// test/features/discovery/question_card_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conficircle/features/discovery/domain/entities/question_prompt_entity.dart';
import 'package:conficircle/features/discovery/presentation/widgets/question_card.dart';

void main() {
  group('QuestionCard Widget Tests (Spec v3.0)', () {
    testWidgets('renders natural-language Level 4 prompt without taxonomy leakage', (tester) async {
      bool tapped = false;
      const question = QuestionPromptEntity(
        questionId: 'q-test-123',
        prompt: 'How do I stop overthinking in group meetings and actually speak up?',
        shortDescription: 'Quick tactics to contribute before hesitation takes over',
        safeReasonLabel: 'Based on what you selected',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              item: question,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Verify question prompt is visible
      expect(
        find.text('How do I stop overthinking in group meetings and actually speak up?'),
        findsOneWidget,
      );

      // Verify short description is visible
      expect(
        find.text('Quick tactics to contribute before hesitation takes over'),
        findsOneWidget,
      );

      // Verify safe reason label is visible
      expect(find.text('Based on what you selected'), findsOneWidget);

      // Verify Explore action button
      expect(find.text('Explore'), findsOneWidget);

      // Verify NO Level 3 / Level 2 / Level 1 taxonomy labels appear
      expect(find.text('Level 3'), findsNothing);
      expect(find.text('Level 2'), findsNothing);
      expect(find.text('Level 1'), findsNothing);
      expect(find.text('Taxonomy'), findsNothing);

      // Tap card
      await tester.tap(find.byType(QuestionCard));
      expect(tapped, isTrue);
    });
  });
}
