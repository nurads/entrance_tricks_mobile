import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';
import 'package:entrance_tricks/views/tabs/video_tab.dart';
import 'package:entrance_tricks/views/tabs/notes_tab.dart';
import 'package:entrance_tricks/views/tabs/quiz_tab.dart';

class ChapterDetail extends StatelessWidget {
  ChapterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChapterDetailController());
    return GetBuilder<ChapterDetailController>(
      builder: (controller) => DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Custom Header
              _buildHeader(context, controller),
              
              // Tab Bar
              Container(
                color: Colors.white,
                child: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.play_circle_outline, size: 24),
                      text: 'Videos',
                    ),
                    Tab(
                      icon: Icon(Icons.description, size: 24),
                      text: 'Notes',
                    ),
                    Tab(
                      icon: Icon(Icons.quiz, size: 24),
                      text: 'Quiz',
                    ),
                  ],
                  indicatorColor: Colors.blue[600],
                  labelColor: Colors.blue[600],
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              // Tab Content
              Expanded(
                child: controller.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : TabBarView(
                        children: [
                          VideoTab(),
                          NotesTab(),
                          QuizTab(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ChapterDetailController controller) {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          
          SizedBox(width: 16),
          
          // Chapter Title
          Expanded(
            child: Text(
              controller.chapterTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
