import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_academy/models/models.dart';
import 'package:vector_academy/views/exam/exam_result_page.dart';
import 'package:vector_academy/utils/storages/storages.dart';
import 'package:vector_academy/services/services.dart';
import 'package:vector_academy/utils/device/device.dart';
import 'package:vector_academy/utils/utils.dart';

enum QuestionMode { practice, exam }

class QuestionPageController extends GetxController {
  // Observable variables
  final RxInt currentQuestionIndex = 0.obs;
  final RxList<int?> userAnswers = <int?>[].obs;
  final RxInt timeRemaining = 0.obs;
  final RxBool isCompleted = false.obs;
  final RxBool showAnswers = false.obs;
  final RxBool showSolution = false.obs;
  final RxBool isSubmitting = false.obs; // Track submission status
  final RxList<bool> submittedQuestions = <bool>[].obs; // Track which questions have been submitted

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
  late String examModeType; // Track exam mode type
  final HiveExamStorage _examStorage = HiveExamStorage();
  final ExamService _examService = ExamService();

  void initializeQuiz({
    required String title,
    required int initialTimeMinutes,
    required List<Question> questions,
    Function(List<int> answers, int timeSpent)? onComplete,
    bool allowReview = true,
    bool showTimer = true,
    QuestionMode mode = QuestionMode.exam,
    int examId = 0,
    String examModeType = 'both',
  }) {
    this.title = title;
    this.initialTimeMinutes = initialTimeMinutes;
    this.questions = questions;
    this.onComplete = onComplete;
    this.allowReview = allowReview;
    this.showTimer = showTimer;
    this.mode = mode;
    this.examId = examId;
    this.examModeType = examModeType;

    // Handle empty questions
    if (questions.isEmpty) {
      userAnswers.value = [];
      timeRemaining.value = 0;
      submittedQuestions.value = [];
      return;
    }

    userAnswers.value = List.filled(questions.length, null);
    submittedQuestions.value = List.filled(questions.length, false);
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
    
    // For exam_mode type, automatically submit the answer
    final modeType = examModeType.toLowerCase();
    if (modeType == 'exam_mode' || modeType == 'exam mode') {
      _submitCurrentAnswer();
    }
  }
  
  /// Submit current question's answer (for exam_mode type)
  Future<void> _submitCurrentAnswer() async {
    if (isSubmitting.value) return; // Prevent double submission
    
    isSubmitting.value = true;
    update();
    
    try {
      final success = await _submitAnswerToServer(currentQuestionIndex.value);
      if (success) {
        submittedQuestions[currentQuestionIndex.value] = true;
      }
    } finally {
      isSubmitting.value = false;
      update();
    }
  }

  Future<bool> _submitAnswerToServer(int questionIndex) async {
    if (examId == 0 ||
        questions.isEmpty ||
        questionIndex < 0 ||
        questionIndex >= questions.length) {
      logger.w('Cannot submit answer: invalid examId or questionIndex');
      return false;
    }

    final answer = userAnswers[questionIndex];
    if (answer == null) {
      logger.w(
        'Cannot submit answer: no answer selected for question $questionIndex',
      );
      return false; // Don't submit if no answer selected
    }

    try {
      final user = await HiveUserStorage().getUser();
      if (user == null) {
        logger.w('Cannot submit answer: user is null');
        return false;
      }

      final device = await UserDevice.getDeviceInfo(user.phoneNumber);
      final question = questions[questionIndex];

      logger.i(
        'Submitting answer: examId=$examId, questionId=${question.id}, choiceId=$answer',
      );
      await _examService.submitAnswers(device.id, examId, question.id, answer);
      logger.i('Successfully submitted answer for question ${question.id}');
      return true;
    } catch (e) {
      // Log the error and show user feedback for exam_mode type
      logger.e('Failed to submit answer for question $questionIndex: $e');
      final modeType = examModeType.toLowerCase();
      if (modeType == 'exam_mode' || modeType == 'exam mode') {
        AppSnackbar.showError(
          'Submission Failed',
          'Failed to submit your answer. Please try again.',
        );
      }
      return false;
    }
  }

  void previousQuestion() {
    if (questions.isNotEmpty && currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      showSolution.value = false; // Reset solution state when navigating
      update();
      _persistProgress();
    }
  }

  void nextQuestion() async {
    if (questions.isEmpty || currentQuestionIndex.value >= questions.length - 1) {
      return;
    }
    
    final modeType = examModeType.toLowerCase();
    final isExamModeType = modeType == 'exam_mode' || modeType == 'exam mode';
    
    // For exam_mode type, check if current question has been successfully submitted
    if (isExamModeType) {
      final currentIndex = currentQuestionIndex.value;
      
      // If not submitted yet, block navigation
      if (!submittedQuestions[currentIndex]) {
        AppSnackbar.showError(
          'Not Submitted',
          'Please wait for your answer to be submitted before moving to the next question.',
        );
        return;
      }
    } else {
      // For other exam types, submit as before (non-blocking)
      await _submitAnswerToServer(currentQuestionIndex.value);
    }

    currentQuestionIndex.value++;
    showSolution.value = false; // Reset solution state when navigating
    update();
    _persistProgress();
  }
  
  /// Check if next button should be enabled
  bool get canMoveToNext {
    if (userAnswers[currentQuestionIndex.value] == null) {
      return false; // No answer selected
    }
    
    final modeType = examModeType.toLowerCase();
    final isExamModeType = modeType == 'exam_mode' || modeType == 'exam mode';
    
    if (isExamModeType) {
      // For exam_mode, must be submitted and not currently submitting
      return submittedQuestions[currentQuestionIndex.value] && !isSubmitting.value;
    }
    
    // For other modes, just need an answer selected
    return true;
  }

  void goToQuestion(int index) {
    if (allowReview &&
        questions.isNotEmpty &&
        index >= 0 &&
        index < questions.length) {
      currentQuestionIndex.value = index;
      showSolution.value = false; // Reset solution state when navigating
    }
  }

  void submitQuiz() async {
    _timer?.cancel();
    
    final modeType = examModeType.toLowerCase();
    final isExamModeType = modeType == 'exam_mode' || modeType == 'exam mode';
    
    // For exam_mode type, check if current question has been submitted
    if (isExamModeType) {
      final currentIndex = currentQuestionIndex.value;
      
      // If not submitted yet, block submission
      if (!submittedQuestions[currentIndex]) {
        AppSnackbar.showError(
          'Not Submitted',
          'Please wait for your answer to be submitted before submitting the exam.',
        );
        return;
      }
    } else {
      // For other exam types, submit the current answer before final submission
      await _submitAnswerToServer(currentQuestionIndex.value);
    }

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

  void toggleSolution() {
    showSolution.value = !showSolution.value;
    update();
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
