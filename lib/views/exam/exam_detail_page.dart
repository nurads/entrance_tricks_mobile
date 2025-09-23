import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/exam/exam_controller.dart';
import 'package:entrance_tricks/views/exam/exam_result_page.dart';
import 'package:entrance_tricks/views/exam/question_page.dart';
import 'package:entrance_tricks/models/models.dart';

class ExamDetailPage extends StatefulWidget {
  final Exam exam;

  const ExamDetailPage({super.key, required this.exam});

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  late ExamController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ExamController());
  }

  @override
  Widget build(BuildContext context) {
    // Get exam data from arguments
    final examTitle = widget.exam.name;
    final timeLimit = widget.exam.duration; // in minutes

    // Create mock math question

    return QuestionPage(
      title: examTitle,
      initialTimeMinutes: timeLimit,
      questions: widget.exam.questions,
      onComplete: (answers, timeSpent) {
        // Calculate results
        final correctAnswers = _calculateCorrectAnswers(
          answers,
          widget.exam.questions,
        );
        final score = (correctAnswers / widget.exam.questions.length * 100)
            .round();

        // Navigate to result page
        Get.to(
          () => ExamResultPage(
            score: score,
            correctAnswers: correctAnswers,
            totalQuestions: widget.exam.questions.length,
          ),
        );
      },
      allowReview: true,
      showTimer: true,
    );
  }

  int _calculateCorrectAnswers(
    List<int> userAnswers,
    List<Question> questions,
  ) {
    // Define correct answers for each question
    final correctAnswers = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

    int correct = 0;
    for (int i = 0; i < userAnswers.length && i < questions.length; i++) {
      if (userAnswers[i] == correctAnswers[i]) {
        correct++;
      }
    }
    return correct;
  }
}
