import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/home/main_navigation_controller.dart';

class ExamResultPage extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int totalQuestions;

  const ExamResultPage({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score Circle
              _buildScoreCircle(context),

              SizedBox(height: 40),

              // Congratulation Message
              _buildCongratulationMessage(context),

              SizedBox(height: 60),

              // Back Button
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue[600],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Score",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "$correctAnswers/$totalQuestions",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCongratulationMessage(BuildContext context) {
    return Column(
      children: [
        Text(
          "Congratulation",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Great job, Yared You Did It",
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        SizedBox(height: 16),
        Text(
          "You scored ${score}% on this exam!",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to exam page
            Get.until((route) => route.settings.name == '/home');
            Get.find<MainNavigationController>().changeIndex(1);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            "Back to Page",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
