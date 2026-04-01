// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

/// Type 1 — "Qui a dit ça ?" : artist identification from a quote
/// Type 2 — "Complète la Punchline" : fill in the missing word (***)
enum QuestionType {
  whoSaidIt,
  completeThePunchline;

  static QuestionType fromString(String value) {
    switch (value) {
      case 'completeThePunchline':
        return QuestionType.completeThePunchline;
      // Legacy / fallback
      case 'multipleChoice':
      case 'whoSaidIt':
      default:
        return QuestionType.whoSaidIt;
    }
  }

  String toJson() {
    switch (this) {
      case QuestionType.completeThePunchline:
        return 'completeThePunchline';
      case QuestionType.whoSaidIt:
        return 'whoSaidIt';
    }
  }
}

class QuestionModel {
  final String id;
  final String packId;
  final QuestionType type;
  final String artistName;
  final String? artistId;
  /// Full quote for TYPE_1 (whoSaidIt), quote with *** for TYPE_2 (completeThePunchline)
  final String quoteText;
  /// Only for TYPE_2 — the missing word
  final String? missingWord;
  /// 4 answer choices
  final List<String> choices;
  final String correctAnswer;
  final int difficulty; // 1-5
  final String sourceTrack;
  final String sourceAlbum;
  final int? sourceYear;
  final String citationLabel;
  final bool isActive;

  const QuestionModel({
    required this.id,
    required this.packId,
    required this.type,
    required this.artistName,
    this.artistId,
    required this.quoteText,
    this.missingWord,
    required this.choices,
    required this.correctAnswer,
    required this.difficulty,
    required this.sourceTrack,
    required this.sourceAlbum,
    this.sourceYear,
    required this.citationLabel,
    required this.isActive,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Support both 'choices' and legacy 'options' field names
    final choicesRaw = json['choices'] ?? json['options'];
    return QuestionModel(
      id: json['id'] as String? ?? '',
      packId: json['packId'] as String? ?? '',
      type: QuestionType.fromString(json['type'] as String? ?? 'whoSaidIt'),
      artistName: json['artistName'] as String? ?? '',
      artistId: json['artistId'] as String?,
      quoteText: json['quoteText'] as String? ?? json['question'] as String? ?? '',
      missingWord: json['missingWord'] as String?,
      choices: List<String>.from(choicesRaw as List? ?? []),
      correctAnswer: json['correctAnswer'] as String? ?? '',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      sourceTrack: json['sourceTrack'] as String? ?? '',
      sourceAlbum: json['sourceAlbum'] as String? ?? '',
      sourceYear: (json['sourceYear'] as num?)?.toInt(),
      citationLabel: json['citationLabel'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packId': packId,
      'type': type.toJson(),
      'artistName': artistName,
      'artistId': artistId,
      'quoteText': quoteText,
      'missingWord': missingWord,
      'choices': choices,
      'correctAnswer': correctAnswer,
      'difficulty': difficulty,
      'sourceTrack': sourceTrack,
      'sourceAlbum': sourceAlbum,
      'sourceYear': sourceYear,
      'citationLabel': citationLabel,
      'isActive': isActive,
    };
  }
}
