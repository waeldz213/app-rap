import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../models/question_model.dart';
import '../../../widgets/glass_card.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int questionNumber;
  final int total;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final label = question.type == QuestionType.whoSaidThis
        ? '🎤 Qui a dit ça ?'
        : '🔤 Complète la punchline';

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$questionNumber / $total',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            question.questionText,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          if (question.sourceTrack != null &&
              !question.sourceTrack!.contains('fictif')) ...[
            const SizedBox(height: 12),
            Text(
              question.sourceTrack!,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
