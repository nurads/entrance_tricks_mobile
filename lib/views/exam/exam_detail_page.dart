import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/exam/exam_controller.dart';
import 'package:entrance_tricks/views/exam/exam_result_page.dart';
import 'package:entrance_tricks/views/exam/question_page.dart';
import 'package:entrance_tricks/models/models.dart';

class ExamDetailPage extends StatefulWidget {
  const ExamDetailPage({super.key});

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
    final examId = Get.arguments?['examId'];
    final examTitle =
        Get.arguments?['examTitle'] ?? 'Mathematics Practice Test';
    final totalQuestions = Get.arguments?['totalQuestions'] ?? 10;
    final timeLimit = Get.arguments?['timeLimit'] ?? 30; // in minutes

    // Create mock math questions
    final mockQuestions = _createMathQuestions();

    return QuestionPage(
      title: examTitle,
      initialTimeMinutes: timeLimit,
      questions: mockQuestions,
      onComplete: (answers, timeSpent) {
        // Calculate results
        final correctAnswers = _calculateCorrectAnswers(answers, mockQuestions);
        final score = (correctAnswers / mockQuestions.length * 100).round();

        // Navigate to result page
        Get.to(
          () => ExamResultPage(
            score: score,
            correctAnswers: correctAnswers,
            totalQuestions: mockQuestions.length,
          ),
        );
      },
      allowReview: true,
      showTimer: true,
    );
  }

  List<Question> _createMathQuestions() {
    return [
      // Question 1: Basic Algebra
      Question(
        id: 1,
        content: r'Solve for x: $2x + 5 = 13$ x^2 + 2x + 1 = 0 $\alpha \beta$',
        choices: [
          Choice(id: 1, content: 'x = 4'),
          Choice(id: 2, content: 'x = 3'),
          Choice(id: 3, content: 'x = 5'),
          Choice(id: 4, content: 'x = 6'),
        ],
      ),

      // Question 2: Quadratic Equation
      Question(
        id: 2,
        content:
            r'Find the roots of the quadratic equation: $x^2 - 5x + 6 = 0$',
        choices: [
          Choice(id: 1, content: 'x = 2, x = 3'),
          Choice(id: 2, content: 'x = 1, x = 6'),
          Choice(id: 3, content: 'x = -2, x = -3'),
          Choice(id: 4, content: 'x = 0, x = 5'),
        ],
      ),

      // Question 3: Trigonometry
      Question(
        id: 3,
        content: r'What is the value of $\\sin(30°)$?',
        choices: [
          Choice(id: 1, content: r'$\frac{1}{2}$'),
          Choice(id: 2, content: r'$\frac{\sqrt{2}}{2}$'),
          Choice(id: 3, content: r'$\frac{\sqrt{3}}{2}$'),
          Choice(id: 4, content: '1'),
        ],
      ),

      // Question 4: Calculus - Derivative
      Question(
        id: 4,
        content: r'Find the derivative of $f(x) = x^3 + 2x^2 - 5x + 1$',
        choices: [
          Choice(id: 1, content: r"$f'(x) = 3x^2 + 4x - 5$"),
          Choice(id: 2, content: r"$f'(x) = 3x^2 + 2x - 5$"),
          Choice(id: 3, content: r"$f'(x) = x^2 + 4x - 5$"),
          Choice(id: 4, content: r"$f'(x) = 3x^2 + 4x + 1$"),
        ],
      ),

      // Question 5: Geometry - Area
      Question(
        id: 5,
        content:
            r'What is the area of a circle with radius $r = 7$ cm? (Use $\pi = \frac{22}{7}$)',
        choices: [
          Choice(id: 1, content: '154 cm²'),
          Choice(id: 2, content: '44 cm²'),
          Choice(id: 3, content: '22 cm²'),
          Choice(id: 4, content: '308 cm²'),
        ],
      ),

      // Question 6: Logarithms
      Question(
        id: 6,
        content: r'Solve for x: $$log_2(x) = 4$$',
        choices: [
          Choice(id: 1, content: 'x = 16'),
          Choice(id: 2, content: 'x = 8'),
          Choice(id: 3, content: 'x = 2'),
          Choice(id: 4, content: 'x = 4'),
        ],
      ),

      // Question 7: Complex Numbers
      Question(
        id: 7,
        content: r'What is the value of $(3 + 4i)(2 - i)$?',
        choices: [
          Choice(id: 1, content: '10 + 5i'),
          Choice(id: 2, content: '6 - 4i'),
          Choice(id: 3, content: '2 + 11i'),
          Choice(id: 4, content: '10 - 5i'),
        ],
      ),

      // Question 8: Probability
      Question(
        id: 8,
        content:
            r'A fair die is rolled. What is the probability of getting an even number?',
        choices: [
          Choice(id: 1, content: r'$\frac{1}{2}$'),
          Choice(id: 2, content: r'$\frac{1}{3}$'),
          Choice(id: 3, content: r'$\frac{1}{6}$'),
          Choice(id: 4, content: r'$\frac{2}{3}$'),
        ],
      ),

      // Question 9: Integration
      Question(
        id: 9,
        content: r'Evaluate: $\\int_0^2 (3x^2 + 2x) dx$',
        choices: [
          Choice(id: 1, content: '12'),
          Choice(id: 2, content: '8'),
          Choice(id: 3, content: '16'),
          Choice(id: 4, content: '10'),
        ],
      ),

      // Question 10: Matrix Operations
      Question(
        id: 10,
        content:
            r'Find the determinant of the matrix: $\\begin{pmatrix} 2 & 3 \\\\ 1 & 4 \\end{pmatrix}$',
        choices: [
          Choice(id: 1, content: '5'),
          Choice(id: 2, content: '11'),
          Choice(id: 3, content: '8'),
          Choice(id: 4, content: '14'),
        ],
      ),

      // Question 11: Limits
      Question(
        id: 11,
        content: r'Find the limit: $\\lim_{x \\to 0} \\frac{\\sin(x)}{x}$',
        choices: [
          Choice(id: 1, content: '1'),
          Choice(id: 2, content: '0'),
          Choice(id: 3, content: r'$\\infty$'),
          Choice(id: 4, content: 'undefined'),
        ],
      ),

      // Question 12: Series
      Question(
        id: 12,
        content:
            r'Find the sum of the arithmetic series: $2 + 5 + 8 + ... + 20$',
        choices: [
          Choice(id: 1, content: '77'),
          Choice(id: 2, content: '66'),
          Choice(id: 3, content: '88'),
          Choice(id: 4, content: '99'),
        ],
      ),

      // Question 13: Functions
      Question(
        id: 13,
        content:
            r'If $f(x) = x^2 + 1$ and $g(x) = 2x - 3$, find $(f \\circ g)(2)$',
        choices: [
          Choice(id: 1, content: '2'),
          Choice(id: 2, content: '5'),
          Choice(id: 3, content: '10'),
          Choice(id: 4, content: '17'),
        ],
      ),

      // Question 14: Statistics
      Question(
        id: 14,
        content: r'Find the mean of the data set: $\\{2, 4, 6, 8, 10\\}$',
        choices: [
          Choice(id: 1, content: '6'),
          Choice(id: 2, content: '5'),
          Choice(id: 3, content: '7'),
          Choice(id: 4, content: '8'),
        ],
      ),

      // Question 15: Coordinate Geometry
      Question(
        id: 15,
        content: r'Find the distance between points $A(1, 2)$ and $B(4, 6)$',
        choices: [
          Choice(id: 1, content: '5'),
          Choice(id: 2, content: r'$\\sqrt{13}$'),
          Choice(id: 3, content: r'$\\sqrt{25}$'),
          Choice(id: 4, content: '7'),
        ],
      ),
    ];
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
