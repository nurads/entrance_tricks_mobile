import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/subject/chapter_detail_controller.dart';
import 'package:entrance_tricks/views/exam/question_page.dart';
import 'package:entrance_tricks/views/quiz/quiz_detail_page.dart';
import 'package:entrance_tricks/models/models.dart';

class QuizTab extends StatelessWidget {
  QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        if (controller.quizzes.isEmpty) {
          return _buildEmptyState(context);
        }

        return Container(
          color: theme.colorScheme.background,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final quiz = controller.quizzes[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildModernQuizCard(context, quiz, controller),
                    );
                  }, childCount: controller.quizzes.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.secondary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.quiz_outlined,
              size: 60,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Quizzes Available',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Quizzes for this chapter will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernQuizCard(
    BuildContext context,
    Exam quiz,
    ChapterDetailController controller,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openQuizDetail(quiz),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Quiz Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.quiz_outlined,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(width: 16),
                    // Quiz Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          // Use Wrap instead of Row to prevent overflow
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      size: 14,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${quiz.totalQuestions} Questions',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant
                                      .withOpacity(0.5  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${quiz.duration} min',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(
                          0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                // Start Quiz Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openQuizDetail(quiz),
                    icon: Icon(Icons.play_arrow, size: 18),
                    label: Text('Start Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openQuizDetail(Exam quiz) {
    Get.to(() => QuestionPage(
          title: quiz.name,
          initialTimeMinutes: quiz.duration,
          questions: quiz.questions,
        ));
  }
}
