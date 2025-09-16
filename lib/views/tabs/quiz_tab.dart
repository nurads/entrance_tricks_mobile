import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';
import 'package:entrance_tricks/views/quiz/quiz_detail_page.dart';

class QuizTab extends StatelessWidget {
  QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        if (controller.quizzes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_outlined, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No quizzes available',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quiz Header
              Text(
                'Quizzes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: controller.quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = controller.quizzes[index];
                    return _buildQuizCard(context, quiz, controller);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizCard(
    BuildContext context,
    Map<String, dynamic> quiz,
    ChapterDetailController controller,
  ) {
    final int attempts = quiz['attempts'] ?? 0;
    final int bestScore = quiz['bestScore'] ?? 0;
    final bool hasAttempted = attempts > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openQuizDetail(quiz),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Quiz Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: hasAttempted ? Colors.green[100] : Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  hasAttempted ? Icons.quiz : Icons.quiz_outlined,
                  size: 30,
                  color: hasAttempted ? Colors.green[600] : Colors.blue[600],
                ),
              ),

              SizedBox(width: 16),

              // Quiz Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz['title'] ?? 'Quiz Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Quiz details row
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${quiz['questions']} Questions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${quiz['duration']} min',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    if (hasAttempted) ...[
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: _getScoreColor(bestScore),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Best Score: $bestScore%',
                            style: TextStyle(
                              fontSize: 14,
                              color: _getScoreColor(bestScore),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '($attempts attempt${attempts > 1 ? 's' : ''})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Action button
              Column(
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  if (hasAttempted) ...[
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getScoreColor(bestScore).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getScoreGrade(bestScore),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getScoreColor(bestScore),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
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
