import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';
import 'package:entrance_tricks/views/quiz/quiz_detail_page.dart';

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
    Map<String, dynamic> quiz,
    ChapterDetailController controller,
  ) {
    final theme = Theme.of(context);
    final int attempts = quiz['attempts'] ?? 0;
    final int bestScore = quiz['bestScore'] ?? 0;
    final bool hasAttempted = attempts > 0;

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
            padding: EdgeInsets.all(16), // Reduced from 20
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Quiz Icon
                    Container(
                      width: 56, // Reduced from 64
                      height: 56, // Reduced from 64
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: hasAttempted
                              ? [
                                  theme.colorScheme.secondary,
                                  theme.colorScheme.secondary.withOpacity(0.8),
                                ]
                              : [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0.8),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(
                          16,
                        ), // Reduced from 18
                        boxShadow: [
                          BoxShadow(
                            color:
                                (hasAttempted
                                        ? theme.colorScheme.secondary
                                        : theme.colorScheme.primary)
                                    .withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        hasAttempted ? Icons.quiz : Icons.quiz_outlined,
                        size: 26, // Reduced from 30
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(width: 16), // Reduced from 20
                    // Quiz Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz['name'] ?? 'Quiz Title',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10), // Reduced from 12
                          // Use Wrap instead of Row to prevent overflow
                          Wrap(
                            spacing: 8, // Reduced from 12
                            runSpacing: 6,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ), // Reduced padding
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Reduced from 16
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      size: 14, // Reduced from 16
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: 4), // Reduced from 6
                                    Text(
                                      '${quiz['questions']} Questions',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            // Changed to labelSmall
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
                                ), // Reduced padding
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Reduced from 16
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14, // Reduced from 16
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: 4), // Reduced from 6
                                    Text(
                                      '${quiz['duration']} min',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            // Changed to labelSmall
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
                      padding: EdgeInsets.all(6), // Reduced from 8
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(
                          0.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Reduced from 12
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 14, // Reduced from 16
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                if (hasAttempted) ...[
                  SizedBox(height: 16), // Reduced from 20
                  // Progress Section
                  Container(
                    padding: EdgeInsets.all(14), // Reduced from 16
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.surfaceVariant.withOpacity(0.3),
                          theme.colorScheme.surfaceVariant.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        14,
                      ), // Reduced from 16
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Best Score',
                              style: theme.textTheme.bodySmall?.copyWith(
                                // Changed to bodySmall
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$bestScore%',
                              style: theme.textTheme.titleSmall?.copyWith(
                                // Changed to titleSmall
                                color: _getScoreColor(bestScore),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10), // Reduced from 12
                        // Progress Bar
                        Container(
                          height: 6, // Reduced from 8
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              6,
                            ), // Reduced from 8
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: bestScore / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getScoreColor(bestScore),
                                    _getScoreColor(bestScore).withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // Reduced from 8
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12), // Reduced from 16

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ), // Reduced padding
                              decoration: BoxDecoration(
                                color: _getScoreColor(
                                  bestScore,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  16,
                                ), // Reduced from 20
                                border: Border.all(
                                  color: _getScoreColor(
                                    bestScore,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getScoreGrade(bestScore),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  // Changed to labelSmall
                                  color: _getScoreColor(bestScore),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '$attempts attempt${attempts > 1 ? 's' : ''}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                // Changed to labelSmall
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  SizedBox(height: 16), // Reduced from 20
                  // Start Quiz Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openQuizDetail(quiz),
                      icon: Icon(Icons.play_arrow, size: 18), // Reduced from 20
                      label: Text('Start Quiz'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                        ), // Reduced from 16
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ), // Reduced from 16
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Color(0xFF10B981); // Green
    if (score >= 60) return Color(0xFFF59E0B); // Orange
    return Color(0xFFEF4444); // Red
  }

  String _getScoreGrade(int score) {
    if (score >= 90) return 'A+';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    return 'F';
  }

  void _openQuizDetail(Map<String, dynamic> quiz) {
    Get.to(() => QuizDetailPage(quiz: quiz));
  }
}
