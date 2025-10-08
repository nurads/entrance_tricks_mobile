import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/exam/exam_controller.dart';
import 'package:entrance_tricks/views/exam/exam_result_page.dart';
import 'package:entrance_tricks/views/exam/question_page.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:entrance_tricks/controllers/exam/question_page_controller.dart';

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

    logger.f("Exam Questions: ${widget.exam.questions.length}");
    logger.f((widget.exam.questions).map((e) => e.toJson()).toList());

    // Create mock math question

    return _ExamModeGate(
      examTitle: examTitle,
      timeLimit: timeLimit,
      questions: widget.exam.questions,
      examId: widget.exam.id,
      onComplete: (answers, timeSpent) {
        final correctAnswers = _calculateCorrectAnswers(
          answers,
          widget.exam.questions,
        );
        final score = (correctAnswers / widget.exam.questions.length * 100)
            .round();
        Get.to(
          () => ExamResultPage(
            score: score,
            correctAnswers: correctAnswers,
            totalQuestions: widget.exam.questions.length,
          ),
        );
      },
    );
  }

  int _calculateCorrectAnswers(
    List<int> userAnswers,
    List<Question> questions,
  ) {
    // Remove hardcoded answers and use actual question data
    int correct = 0;
    for (int i = 0; i < userAnswers.length && i < questions.length; i++) {
      final question = questions[i];
      final userAnswerId = userAnswers[i];

      // Find the correct choice for this question
      final correctChoice = question.choices.firstWhere(
        (choice) => choice.isCorrect,
        orElse: () =>
            question.choices.first, // fallback if no correct choice found
      );

      if (userAnswerId == correctChoice.id) {
        correct++;
      }
    }
    return correct;
  }
}

class _ExamModeGate extends StatefulWidget {
  final String examTitle;
  final int timeLimit;
  final List<Question> questions;
  final Function(List<int> answers, int timeSpent)? onComplete;
  final int examId;

  const _ExamModeGate({
    required this.examTitle,
    required this.timeLimit,
    required this.questions,
    required this.examId,
    this.onComplete,
  });

  @override
  State<_ExamModeGate> createState() => _ExamModeGateState();
}

class _ExamModeGateState extends State<_ExamModeGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModePicker();
    });
  }

  void _showModePicker() async {
    final mode = await showDialog<_ExamMode>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: EdgeInsets.only(top: 20, left: 24, right: 24),
          contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Mode',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'How would you like to take this exam?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ModeCard(
                accent: theme.colorScheme.primary,
                icon: Icons.school,
                title: 'Practice Mode',
                subtitle: 'See correctness instantly and review as you go',
                badgeText: 'Recommended for learning',
                onTap: () => Navigator.of(context).pop(_ExamMode.practice),
              ),
              SizedBox(height: 12),
              _ModeCard(
                accent: theme.colorScheme.secondary,
                icon: Icons.fact_check,
                title: 'Exam Mode',
                subtitle: 'No feedback until you submit at the end',
                badgeText: 'Simulates real exam',
                onTap: () => Navigator.of(context).pop(_ExamMode.exam),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (mode == null) {
      Get.back();
      return;
    }

    final isPractice = mode == _ExamMode.practice;
    Get.off(
      () => QuestionPage(
        title: widget.examTitle,
        initialTimeMinutes: widget.timeLimit,
        questions: widget.questions,
        onComplete: widget.onComplete,
        allowReview: true,
        showTimer: true,
        mode: isPractice ? QuestionMode.practice : QuestionMode.exam,
        examId: widget.examId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox.shrink());
  }
}

enum _ExamMode { practice, exam }

class _ModeCard extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
  final VoidCallback onTap;

  const _ModeCard({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (badgeText != null) ...[
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.75,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
