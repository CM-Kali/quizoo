class Question {
  final String question;
  final List<String> options;
  final int answerIndex;

  Question({
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      answerIndex: json['answer'],
    );
  }
}
