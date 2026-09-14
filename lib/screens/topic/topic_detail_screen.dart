// lib/screens/topic/topic_detail_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock_topics.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TopicDetailScreen extends StatelessWidget {
  final AppTopic topic;
  const TopicDetailScreen({super.key, required this.topic});

  Color get topicColor => Color(topic.colorHex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: Column(
        children: [
          // ── Fixed gradient header ────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [topicColor, topicColor.withOpacity(0.82)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button row
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Emoji + title + subtitle
                    Text(topic.emoji, style: const TextStyle(fontSize: 44)),
                    const SizedBox(height: 8),
                    Text(
                      topic.title,
                      style: AppTypography.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.subtitle,
                      style: AppTypography.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable body ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                const SizedBox(height: 20),

                // ── Quick Tips ─────────────────────────────────────
                _SectionLabel(label: '⚡  Quick Tips', accent: topicColor),
                const SizedBox(height: 12),
                ...topic.tips.map((tip) => _TipCard(tip: tip, color: topicColor)),

                const SizedBox(height: 24),

                // ── Quick Assessment CTA ───────────────────────────
                _QuickAssessmentBanner(topic: topic, topicColor: topicColor),

                const SizedBox(height: 24),

                // ── Resources ──────────────────────────────────────
                _SectionLabel(label: '📚  Resources for You', accent: topicColor),
                const SizedBox(height: 12),
                ...topic.resources.map((r) => _ResourceTile(resource: r, topicColor: topicColor)),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color accent;
  const _SectionLabel({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(label,
          style: AppTypography.montserrat(
            fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.blue,
          )),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Quick Tip Card
// ─────────────────────────────────────────────────────────────
class _TipCard extends StatelessWidget {
  final TopicTip tip;
  final Color color;
  const _TipCard({required this.tip, required this.color});

  IconData get _typeIcon {
    switch (tip.type) {
      case 'video': return Icons.play_circle_fill_rounded;
      case 'article': return Icons.article_outlined;
      case 'quote': return Icons.format_quote_rounded;
      default: return Icons.bolt_rounded;
    }
  }

  String get _typeLabel {
    switch (tip.type) {
      case 'video': return 'VIDEO';
      case 'article': return 'ARTICLE';
      case 'quote': return 'INSIGHT';
      default: return 'CHALLENGE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_typeIcon, size: 13, color: color),
                    const SizedBox(width: 5),
                    Text(_typeLabel,
                        style: AppTypography.montserrat(
                          fontSize: 10, fontWeight: FontWeight.w800, color: color,
                          letterSpacing: 0.5,
                        )),
                  ],
                ),
              ),
              const Spacer(),
              if (tip.duration != null)
                Text(tip.duration!,
                    style: AppTypography.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          Text(tip.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(tip.title,
              style: AppTypography.montserrat(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.blue,
              )),
          const SizedBox(height: 6),
          Text(tip.body,
              style: AppTypography.bodyMedium.copyWith(height: 1.55)),
          if (tip.type == 'video') ...[
            const SizedBox(height: 14),
            // Fake video player placeholder
            Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.85), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 32),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Quick Assessment Banner
// ─────────────────────────────────────────────────────────────
class _QuickAssessmentBanner extends StatelessWidget {
  final AppTopic topic;
  final Color topicColor;
  const _QuickAssessmentBanner({required this.topic, required this.topicColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [topicColor, topicColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: topicColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text('QUICK ASSESSMENT',
                      style: AppTypography.montserrat(
                        fontSize: 9, fontWeight: FontWeight.w800,
                        color: Colors.white, letterSpacing: 0.8,
                      )),
                ),
                const SizedBox(height: 10),
                Text('Test your knowledge\non ${topic.title}',
                    style: AppTypography.montserrat(
                      fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3,
                    )),
                const SizedBox(height: 6),
                Text('5 questions · 2 min timer',
                    style: AppTypography.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.75),
                    )),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: topicColor,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => TopicAssessmentScreen(topic: topic),
                    ));
                  },
                  child: Text('Start Assessment →',
                      style: AppTypography.montserrat(
                        fontSize: 13, fontWeight: FontWeight.w800, color: topicColor,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text('⏱️', style: const TextStyle(fontSize: 52)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Resource Tile
// ─────────────────────────────────────────────────────────────
class _ResourceTile extends StatelessWidget {
  final TopicResource resource;
  final Color topicColor;
  const _ResourceTile({required this.resource, required this.topicColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: topicColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(resource.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: topicColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(resource.tag,
                            style: AppTypography.montserrat(
                              fontSize: 9, fontWeight: FontWeight.w800,
                              color: topicColor, letterSpacing: 0.4,
                            )),
                      ),
                      const SizedBox(width: 8),
                      Text(resource.duration,
                          style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(resource.title,
                      style: AppTypography.montserrat(
                        fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.blue,
                      )),
                  Text(resource.subtitle,
                      style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: topicColor),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// TOPIC ASSESSMENT SCREEN (timed, 5 questions, 2 minutes)
// ═════════════════════════════════════════════════════════════
class TopicAssessmentScreen extends StatefulWidget {
  final AppTopic topic;
  const TopicAssessmentScreen({super.key, required this.topic});

  @override
  State<TopicAssessmentScreen> createState() => _TopicAssessmentScreenState();
}

class _TopicAssessmentScreenState extends State<TopicAssessmentScreen> {
  static const int _totalSeconds = 120; // 2 minutes
  int _secondsLeft = _totalSeconds;
  int _currentQ = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        _timer?.cancel();
        setState(() => _finished = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    final correct = widget.topic.questions[_currentQ].correctIndex;
    setState(() {
      _selected = index;
      _answered = true;
      if (index == correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 900), _nextQuestion);
  }

  void _nextQuestion() {
    if (_currentQ < widget.topic.questions.length - 1) {
      setState(() {
        _currentQ++;
        _selected = null;
        _answered = false;
      });
    } else {
      _timer?.cancel();
      setState(() => _finished = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color get topicColor => Color(widget.topic.colorHex);

  String get _timeDisplay {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  bool get _isLowTime => _secondsLeft <= 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: topicColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${widget.topic.emoji}  ${widget.topic.title} Quiz',
            style: AppTypography.montserrat(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
            )),
        actions: [
          // Timer
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isLowTime
                  ? AppColors.coral.withOpacity(0.9)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_rounded,
                    size: 14, color: _isLowTime ? Colors.white : Colors.white70),
                const SizedBox(width: 5),
                Text(_timeDisplay,
                    style: AppTypography.montserrat(
                      fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,
                    )),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentQ + (_answered ? 1 : 0)) / widget.topic.questions.length,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ),
      ),
      body: _finished ? _buildResult() : _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = widget.topic.questions[_currentQ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Question ${_currentQ + 1} of ${widget.topic.questions.length}',
              style: AppTypography.bodySmall.copyWith(color: topicColor)),
          const SizedBox(height: 10),
          Text(q.question,
              style: AppTypography.montserrat(
                fontSize: 18, fontWeight: FontWeight.w700,
                color: AppColors.blue, height: 1.4,
              )),
          const SizedBox(height: 24),
          ...q.options.asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value;
            final isSelected = _selected == i;
            final isCorrect = _answered && i == q.correctIndex;
            final isWrong = _answered && isSelected && i != q.correctIndex;

            Color bgColor = AppColors.white;
            Color borderColor = AppColors.lightGrey;
            Color textColor = AppColors.blue;

            if (isCorrect) { bgColor = const Color(0xFFE8F8EE); borderColor = AppColors.success; textColor = AppColors.success; }
            if (isWrong) { bgColor = const Color(0xFFFEECEA); borderColor = AppColors.coral; textColor = AppColors.coral; }

            return GestureDetector(
              onTap: () => _selectAnswer(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCorrect
                            ? AppColors.success
                            : isWrong
                                ? AppColors.coral
                                : isSelected
                                    ? topicColor
                                    : AppColors.softGrey,
                      ),
                      child: Center(
                        child: isCorrect
                            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                            : isWrong
                                ? const Icon(Icons.close_rounded, size: 14, color: Colors.white)
                                : Text(String.fromCharCode(65 + i),
                                    style: AppTypography.montserrat(
                                      fontSize: 11, fontWeight: FontWeight.w800,
                                      color: isSelected ? Colors.white : AppColors.darkGrey,
                                    )),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(opt,
                          style: AppTypography.montserrat(
                            fontSize: 13, fontWeight: FontWeight.w600, color: textColor,
                          )),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = widget.topic.questions.length;
    final pct = (_score / total * 100).round();
    final isGreat = pct >= 80;
    final isOk = pct >= 50;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isGreat ? '🎉' : isOk ? '👍' : '💪',
                style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              isGreat ? 'Excellent!' : isOk ? 'Good effort!' : 'Keep practising!',
              style: AppTypography.headingLarge,
            ),
            const SizedBox(height: 8),
            Text('You scored $_score out of $total on ${widget.topic.title}',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium),
            const SizedBox(height: 24),
            // Score circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [topicColor, topicColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: topicColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text('$pct%',
                    style: AppTypography.montserrat(
                      fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white,
                    )),
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: topicColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Back to ${widget.topic.title}',
                    style: AppTypography.montserrat(
                      fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white,
                    )),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // pop assessment
                Navigator.pop(context); // pop topic detail
              },
              child: Text('Back to Home',
                  style: AppTypography.montserrat(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkGrey,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
