import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/models/models.dart';

class QuestionPageController extends GetxController {
  // Observable variables
  final RxInt currentQuestionIndex = 0.obs;
  final RxList<int?> userAnswers = <int?>[].obs;
  final RxInt timeRemaining = 0.obs;
  final RxBool isCompleted = false.obs;
  final RxBool showAnswers = false.obs;

  // Timer
  Timer? _timer;

  // Widget parameters
  late String title;
  late int initialTimeMinutes;
  late List<Question> questions;
  late Function(List<int> answers, int timeSpent)? onComplete;
  late bool allowReview;
  late bool showTimer;

  void initializeQuiz({
    required String title,
    required int initialTimeMinutes,
    required List<Question> questions,
    Function(List<int> answers, int timeSpent)? onComplete,
    bool allowReview = true,
    bool showTimer = true,
  }) {
    this.title = title;
    this.initialTimeMinutes = initialTimeMinutes;
    this.questions = questions;
    this.onComplete = onComplete;
    this.allowReview = allowReview;
    this.showTimer = showTimer;

    userAnswers.value = List.filled(questions.length, null);
    timeRemaining.value = initialTimeMinutes * 60;
    if (showTimer) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        _timeUp();
      }
    });
  }

  void _timeUp() {
    _timer?.cancel();
    isCompleted.value = true;
    _showTimeUpDialog();
  }

  void _showTimeUpDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Time\'s Up!'),
        content: Text(
          'The time limit has been reached. Your answers will be submitted automatically.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              submitQuiz();
            },
            child: Text('Submit'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void selectAnswer(int choiceId) {
    userAnswers[currentQuestionIndex.value] = choiceId;
    update();
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      update();
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      update();
    }
  }

  void goToQuestion(int index) {
    if (allowReview) {
      currentQuestionIndex.value = index;
    }
  }

  void submitQuiz() {
    _timer?.cancel();
    isCompleted.value = true;
  }

  void reviewAnswers() {
    showAnswers.value = true;
    currentQuestionIndex.value = 0;
  }

  void finishQuiz() {
    final timeSpent = (initialTimeMinutes * 60) - timeRemaining.value;
    onComplete?.call(userAnswers.cast<int>().toList(), timeSpent);
    Get.back();
  }

  int calculateCorrectAnswers() {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      final userAnswer = userAnswers[i];
      if (userAnswer != null) {
        final question = questions[i];
        if (question.choices.isNotEmpty &&
            userAnswer == question.choices.first.id) {
          correct++;
        }
      }
    }
    return correct;
  }

  void showImageDialog(String? imageUrl) {
    if (imageUrl == null) return;

    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text('Question Image'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              Expanded(
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Center(child: Text('Failed to load image')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showQuitDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Quit Quiz?'),
        content: Text(
          'Are you sure you want to quit? Your progress will be lost.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: Text('Quit'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
