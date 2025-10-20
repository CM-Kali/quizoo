import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../screens/result_screen.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuizScreen extends StatefulWidget {
  final String level;
  const QuizScreen({super.key, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final data = await rootBundle.loadString('lib/data/questions.json');
    final jsonData = json.decode(data);
    final levelData = jsonData[widget.level] as List;
    setState(() {
      questions = levelData.map((q) => Question.fromJson(q)).toList();
    });
  }

  void checkAnswer(int index) {
    setState(() {
      selectedIndex = index;
      answered = true;
      if (index == questions[currentQuestionIndex].answerIndex) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          answered = false;
          selectedIndex = null;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(score: score, total: questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('${widget.level.toUpperCase()} QUIZ',
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${currentQuestionIndex + 1}: ${question.question}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final option = question.options[index];
              final correct = question.answerIndex == index;
              final isSelected = selectedIndex == index;
              Color color = Colors.white;
              if (answered && isSelected) {
                color = correct ? Colors.greenAccent : Colors.redAccent;
              }

              return GestureDetector(
                onTap: () {
                  if (!answered) checkAnswer(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal, width: 1.5),
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
