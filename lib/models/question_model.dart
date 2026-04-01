import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionType {
  multipleChoice,
  trueFalse;

  static QuestionType fromString(String value) {
    switch (value) {
      case 'trueFalse':
        return QuestionType.trueFalse;
      default:
        return QuestionType.multipleChoice;
    }
  }

  String toJson() {
    switch (this) {
      case QuestionType.trueFalse:
        return 'trueFalse';
      case QuestionType.multipleChoice:
        return 'multipleChoice';
    }
  }
}

class QuestionModel {
  final String id;
  final String packId;
  final QuestionType type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final int difficulty;
  final String? mediaUrl;
  final bool isActive;

  const QuestionModel({
    required this.id,
    required this.packId,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    required this.difficulty,
    this.mediaUrl,
    required this.isActive,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      packId: json['packId'] as String,
      type: QuestionType.fromString(json['type'] as String? ?? 'multipleChoice'),
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List? ?? []),
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String?,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      mediaUrl: json['mediaUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packId': packId,
      'type': type.toJson(),
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'difficulty': difficulty,
      'mediaUrl': mediaUrl,
      'isActive': isActive,
    };
  }
}
