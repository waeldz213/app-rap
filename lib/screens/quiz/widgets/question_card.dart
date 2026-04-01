import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../models/question_model.dart';
import '../../../widgets/glass_card.dart';
import '../../../config/theme.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int questionNumber;
  final int totalQuestions;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final isWhoSaidIt = question.type == QuestionType.whoSaidIt;
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: isWhoSaidIt
                  ? AppTheme.premiumGradient
                  : AppTheme.fireGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isWhoSaidIt ? '🎤 Qui a dit ça ?' : '✍️ Complète la punchline',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Quote text
          Text(
            '"${question.quoteText}"',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          // Citation label
          if (question.citationLabel.isNotEmpty)
            Text(
              '— ${question.citationLabel}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}
