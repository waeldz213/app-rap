enum QuestionType {
  whoSaidThis, // Type 1: Qui a dit ça?
  completePunchline, // Type 2: Complète la punchline
}

class QuestionModel {
  final String id;
  final String packId;
  final QuestionType type;
  final String questionText;
  final String correctAnswer;
  final List<String> choices;
  final String? missingWord; // For type 2: the word to find
  final String? artistName; // For type 1
  final String? sourceTrack;
  final String? sourceAlbum;
  final int difficulty; // 1-3
  final bool isActive;
  final DateTime? createdAt;

  const QuestionModel({
    required this.id,
    required this.packId,
    required this.type,
    required this.questionText,
    required this.correctAnswer,
    required this.choices,
    this.missingWord,
    this.artistName,
    this.sourceTrack,
    this.sourceAlbum,
    this.difficulty = 1,
    this.isActive = true,
    this.createdAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json, String id) {
    return QuestionModel(
      id: id,
      packId: json['packId'] as String? ?? '',
      type: json['type'] == 'completePunchline'
          ? QuestionType.completePunchline
          : QuestionType.whoSaidThis,
      questionText: json['questionText'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? '',
      choices: List<String>.from(json['choices'] as List? ?? []),
      missingWord: json['missingWord'] as String?,
      artistName: json['artistName'] as String?,
      sourceTrack: json['sourceTrack'] as String?,
      sourceAlbum: json['sourceAlbum'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String? ?? '')
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'packId': packId,
        'type': type == QuestionType.completePunchline
            ? 'completePunchline'
            : 'whoSaidThis',
        'questionText': questionText,
        'correctAnswer': correctAnswer,
        'choices': choices,
        'missingWord': missingWord,
        'artistName': artistName,
        'sourceTrack': sourceTrack,
        'sourceAlbum': sourceAlbum,
        'difficulty': difficulty,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
      };
}
