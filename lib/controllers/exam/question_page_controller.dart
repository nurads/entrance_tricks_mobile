import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/views/exam/exam_result_page.dart';
import 'package:entrance_tricks/utils/storages/storages.dart';

enum QuestionMode { practice, exam }

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
  late QuestionMode mode;
  late int examId;
  final HiveExamStorage _examStorage = HiveExamStorage();

  void initializeQuiz({
    required String title,
    required int initialTimeMinutes,
    required List<Question> questions,
    Function(List<int> answers, int timeSpent)? onComplete,
    bool allowReview = true,
    bool showTimer = true,
    QuestionMode mode = QuestionMode.exam,
    int examId = 0,
  }) {
    this.title = title;
    this.initialTimeMinutes = initialTimeMinutes;
    this.questions = questions;
    this.onComplete = onComplete;
    this.allowReview = allowReview;
    this.showTimer = showTimer;
    this.mode = mode;
    this.examId = examId;

    // Handle empty questions
    if (questions.isEmpty) {
      userAnswers.value = [];
      timeRemaining.value = 0;
      return;
    }

    userAnswers.value = List.filled(questions.length, null);
    timeRemaining.value = initialTimeMinutes * 60;
    _restoreProgressIfAny();
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
    // Block changing answers once finished or in review for both modes
    if (isCompleted.value || showAnswers.value) {
      return;
    }
    // Additionally, in practice mode during the attempt, once an answer
    // is chosen for the current question, prevent changing it.
    if (mode == QuestionMode.practice &&
        userAnswers.isNotEmpty &&
        userAnswers[currentQuestionIndex.value] != null) {
      return;
    }
    userAnswers[currentQuestionIndex.value] = choiceId;
    update();
    _persistProgress();
  }

  void previousQuestion() {
    if (questions.isNotEmpty && currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      update();
      _persistProgress();
    }
  }

  void nextQuestion() {
    if (questions.isNotEmpty &&
        currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      update();
      _persistProgress();
    }
  }

  void goToQuestion(int index) {
    if (allowReview &&
        questions.isNotEmpty &&
        index >= 0 &&
        index < questions.length) {
      currentQuestionIndex.value = index;
    }
  }

  void submitQuiz() {
    _timer?.cancel();
    isCompleted.value = true;
    _examStorage.clearProgress(
      examId,
      mode == QuestionMode.practice ? 'practice' : 'exam',
    );
    _examStorage.markCompleted(examId);
    Get.to(
      () => ExamResultPage(
        score: calculateCorrectAnswers(),
        totalQuestions: questions.length,
        correctAnswers: calculateCorrectAnswers(),
      ),
    );
  }

  void reviewAnswers() {
    showAnswers.value = true;
    currentQuestionIndex.value = 0;
    update();
  }

  void finishQuiz() {
    final timeSpent = (initialTimeMinutes * 60) - timeRemaining.value;
    onComplete?.call(userAnswers.cast<int>().toList(), timeSpent);
    Get.back();
  }

  int calculateCorrectAnswers() {
    if (questions.isEmpty) return 0;

    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      final userAnswer = userAnswers[i];
      if (userAnswer != null) {
        final question = questions[i];
        // Find the correct choice by checking isCorrect property
        final correctChoice = question.choices.firstWhereOrNull(
          (choice) => choice.isCorrect,
        );
        if (userAnswer == correctChoice?.id) {
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
    _persistProgress();
    super.onClose();
  }

  Future<void> _restoreProgressIfAny() async {
    if (examId == 0) return;
    final saved = await _examStorage.getProgress(
      examId,
      mode == QuestionMode.practice ? 'practice' : 'exam',
    );
    if (saved == null) return;

    final savedIndex = (saved['current_question_index'] as num?)?.toInt() ?? 0;
    final savedAnswers =
        (saved['selected_answers'] as List<dynamic>?)
            ?.map((e) => e == null ? null : (e as num).toInt())
            .toList() ??
        [];
    final savedRemaining = (saved['remaining_time'] as num?)?.toInt();

    if (savedAnswers.isNotEmpty && savedAnswers.length == questions.length) {
      userAnswers.value = List<int?>.from(savedAnswers);
    }
    currentQuestionIndex.value = savedIndex.clamp(
      0,
      (questions.length - 1).clamp(0, questions.length),
    );
    if (savedRemaining != null && savedRemaining > 0) {
      timeRemaining.value = savedRemaining;
    }
    // Do not override current mode; we load only the progress for the active mode
    update();
  }

  void _persistProgress() {
    if (examId == 0) return;
    _examStorage.saveProgress(
      examId,
      currentIndex: currentQuestionIndex.value,
      answers: userAnswers.toList(),
      timeRemaining: timeRemaining.value,
      mode: mode == QuestionMode.practice ? 'practice' : 'exam',
    );
  }
}
