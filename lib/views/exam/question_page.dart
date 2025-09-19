import 'package:entrance_tricks/utils/latex_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/controllers/exam/question_page_controller.dart';

class QuestionPage extends StatelessWidget {
  final String title;
  final int initialTimeMinutes;
  final List<Question> questions;
  final Function(List<int> answers, int timeSpent)? onComplete;
  final bool allowReview;
  final bool showTimer;

  const QuestionPage({
    super.key,
    required this.title,
    required this.initialTimeMinutes,
    required this.questions,
    this.onComplete,
    this.allowReview = true,
    this.showTimer = true,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(QuestionPageController());

    // Initialize the quiz data
    controller.initializeQuiz(
      title: title,
      initialTimeMinutes: initialTimeMinutes,
      questions: questions,
      onComplete: onComplete,
      allowReview: allowReview,
      showTimer: showTimer,
    );

    return GetBuilder<QuestionPageController>(
      builder: (controller) {
        if (controller.isCompleted.value && !controller.showAnswers.value) {
          return _buildResultsPage(context, controller);
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: _buildAppBar(context, controller),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Timer if enabled
                  if (showTimer) _buildTimer(context, controller),

                  SizedBox(height: 16),

                  // Question content
                  _buildQuestionCard(
                    context,
                    controller.questions[controller.currentQuestionIndex.value],
                    controller.currentQuestionIndex.value + 1,
                  ),

                  SizedBox(height: 20),

                  // Choices
                  _buildChoicesSection(
                    context,
                    controller
                        .questions[controller.currentQuestionIndex.value]
                        .choices,
                    controller,
                  ),

                  SizedBox(height: 24),

                  // Navigation
                  _buildNavigationSection(context, controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    QuestionPageController controller,
  ) {
    return AppBar(
      title: Text(controller.title),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      elevation: 0,
    );
  }

  Widget _buildTimer(BuildContext context, QuestionPageController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 16,
          ),
          SizedBox(width: 8),
          Obx(
            () => Text(
              _formatTime(controller.timeRemaining.value),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    Question question,
    int questionNumber,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Question $questionNumber',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Question content with LaTeX support
            _buildQuestionContent(context, question.content),

            // Image if available
            if (question.image != null && question.image!.isNotEmpty) ...[
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  question.image!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Image failed to load',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(BuildContext context, String content) {
    if (LaTeXUtils.containsLaTeX(content)) {
      return TeXWidget(math: content);
    } else {
      return Text(content, style: TextStyle(fontSize: 12));
    }
  }

  Widget _buildChoicesSection(
    BuildContext context,
    List<Choice> choices,
    QuestionPageController controller,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your answer:',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            ...choices.asMap().entries.map((entry) {
              final index = entry.key;
              final choice = entry.value;
              final choiceLabel = String.fromCharCode(65 + index); // A, B, C, D

              return Obx(() {
                final isSelected =
                    controller.userAnswers[controller
                        .currentQuestionIndex
                        .value] ==
                    choice.id;

                return _buildChoiceItem(
                  context,
                  choice,
                  choiceLabel,
                  isSelected,
                  () => controller.selectAnswer(choice.id),
                );
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceItem(
    BuildContext context,
    Choice choice,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Choice label (A, B, C, D)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 16),

            // Choice content
            Expanded(child: _buildChoiceContent(context, choice.content)),

            // Selection indicator
            if (isSelected) ...[
              SizedBox(width: 12),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: theme.colorScheme.onPrimary,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceContent(BuildContext context, String content) {
    if (LaTeXUtils.containsLaTeX(content)) {
      return TeXWidget(math: content);
    } else {
      return Text(content, style: TextStyle(fontSize: 12));
    }
  }

  Widget _buildNavigationSection(
    BuildContext context,
    QuestionPageController controller,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Question progress indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Obx(
            () => Text(
              '${controller.currentQuestionIndex.value + 1} / ${controller.questions.length}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: 16),

        // Navigation buttons
        Obx(() {
          final canGoPrevious = controller.currentQuestionIndex.value > 0;
          final canGoNext =
              controller.userAnswers[controller.currentQuestionIndex.value] !=
              null;
          final isLastQuestion =
              controller.currentQuestionIndex.value ==
              controller.questions.length - 1;

          return Row(
            children: [
              // Previous button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: canGoPrevious ? controller.previousQuestion : null,
                  icon: Icon(Icons.arrow_back),
                  label: Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Next/Submit button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canGoNext
                      ? (isLastQuestion
                            ? controller.submitQuiz
                            : controller.nextQuestion)
                      : null,
                  icon: Icon(
                    isLastQuestion ? Icons.check : Icons.arrow_forward,
                  ),
                  label: Text(isLastQuestion ? 'Submit' : 'Next'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildResultsPage(
    BuildContext context,
    QuestionPageController controller,
  ) {
    final theme = Theme.of(context);
    final correctAnswers = controller.calculateCorrectAnswers();
    final totalQuestions = controller.questions.length;
    final percentage = (correctAnswers / totalQuestions * 100).round();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Results Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Quiz Completed!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Score Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      '$correctAnswers/$totalQuestions',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      '$percentage%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.reviewAnswers,
                      icon: Icon(Icons.quiz),
                      label: Text('Review Answers'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.finishQuiz,
                      icon: Icon(Icons.check),
                      label: Text('Finish'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
