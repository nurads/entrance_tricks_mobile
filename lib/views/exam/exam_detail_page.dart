import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/exam_controller.dart';
import 'package:entrance_tricks/views/exam/exam_result_page.dart';

class ExamDetailPage extends StatefulWidget {
  const ExamDetailPage({super.key});

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  late ExamController controller;
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  List<Map<String, dynamic>> userAnswers = [];
  bool isExamCompleted = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ExamController());
    _initializeExam();
  }

  void _initializeExam() {
    final examId = Get.arguments['examId'];
    // For now, we'll use mock questions
    // In the future, this will fetch questions from API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            _buildTopBar(context),
            
            // Question Card
            Expanded(
              child: _buildQuestionCard(context),
            ),
            
            // Navigation Buttons
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Arrow
          GestureDetector(
            onTap: () => Get.back(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          
          SizedBox(width: 16),
          
          // Exam Title and Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Maths Exam One",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "30 Question",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Timer
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: Colors.orange[700],
                ),
                SizedBox(width: 4),
                Text(
                  "16:35",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    // Mock question data - in future this will come from API
    final Map<String, dynamic> mockQuestion = {
      'question': 'Who is making the Web standards?',
      'options': [
        'The World Wide Web Consortium',
        'Microsoft',
        'Mozilla',
        'Google',
      ],
      'correctAnswer': 0,
    };

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress and Quit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question: ${currentQuestionIndex + 1}/30",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => _showQuitDialog(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: Text("Quit"),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Question Text
          Text(
            mockQuestion['question'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          
          SizedBox(height: 32),
          
          // Options
          ...List.generate(
            mockQuestion['options'].length,
            (index) => _buildOptionButton(
              context,
              mockQuestion['options'][index],
              index,
              mockQuestion['correctAnswer'] == index,
            ),
          ),
          
          Spacer(),
          
          // See Result Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  "See Result",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String option, int index, bool isCorrect) {
    final isSelected = selectedAnswer == index;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedAnswer = index;
            userAnswers.add({
              'questionIndex': currentQuestionIndex,
              'selectedAnswer': index,
              'isCorrect': isCorrect,
            });
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          elevation: 0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // Previous Button
          Expanded(
            child: ElevatedButton(
              onPressed: currentQuestionIndex > 0 ? () {
                setState(() {
                  currentQuestionIndex--;
                  selectedAnswer = userAnswers
                      .where((answer) => answer['questionIndex'] == currentQuestionIndex)
                      .firstOrNull?['selectedAnswer'];
                });
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Previous",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          SizedBox(width: 16),
          
          // Next Button
          Expanded(
            child: ElevatedButton(
              onPressed: selectedAnswer != null ? () {
                if (currentQuestionIndex < 29) {
                  setState(() {
                    currentQuestionIndex++;
                    selectedAnswer = userAnswers
                        .where((answer) => answer['questionIndex'] == currentQuestionIndex)
                        .firstOrNull?['selectedAnswer'];
                  });
                } else {
                  // Exam completed, show results
                  _showResults();
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                currentQuestionIndex < 29 ? "Next" : "Finish",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quit Exam"),
          content: Text("Are you sure you want to quit this exam? Your progress will be lost."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.back();
              },
              child: Text("Quit", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showResults() {
    final correctAnswers = userAnswers.where((answer) => answer['isCorrect'] == true).length;
    final totalQuestions = 30;
    final score = (correctAnswers / totalQuestions * 100).round();
    
    Get.to(() => ExamResultPage(
      score: score,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
    ));
  }
}
