import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';
import 'package:entrance_tricks/views/quiz_detail_page.dart';

class QuizTab extends StatelessWidget {
  QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Quiz Cards
              Expanded(
                child: ListView.builder(
                  itemCount: 2, // Show 2 quiz cards as per design
                  itemBuilder: (context, index) {
                    return _buildQuizCard(context, index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizCard(BuildContext context, int index) {
    final quizData = [
      {
        'title': 'Chapter One',
        'questions': '10 Question',
        'duration': '1 hour 15 min',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
      },
      {
        'title': 'Chapter One',
        'questions': '10 Question',
        'duration': '1 hour 15 min',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
      },
    ];

    final quiz = quizData[index];

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => _openQuizDetail(index),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
                      children: [
                // Quiz Image
                        Container(
                  width: 80,
                  height: 80,
                          decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      quiz['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.quiz,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                SizedBox(width: 20),
                
                // Quiz Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                        quiz['title']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      SizedBox(height: 8),
                      
                                  Text(
                        quiz['questions']!,
                                    style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      SizedBox(height: 4),
                      
                                  Text(
                        quiz['duration']!,
                                    style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                ),
                
                // Download Icon
                GestureDetector(
                  onTap: () => _downloadQuiz(index),
                  child: Icon(
                    Icons.download,
                    size: 24,
                    color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  void _openQuizDetail(int index) {
    final quizData = {
      'title': 'Chapter One Quiz',
      'questions': 10,
      'duration': '1 hour 15 min',
    };
    
    Get.to(() => QuizDetailPage(quiz: quizData));
  }

  void _downloadQuiz(int index) {
    Get.snackbar('Info', 'Quiz download will be implemented');
  }
}
