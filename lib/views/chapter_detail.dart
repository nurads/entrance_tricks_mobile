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
          appBar: AppBar(
            title: Text(controller.chapterTitle),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.play_circle_outline), text: 'Videos'),
                Tab(icon: Icon(Icons.description), text: 'Notes'),
                Tab(icon: Icon(Icons.quiz), text: 'Quiz'),
              ],
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
            ),
          ),
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : TabBarView(children: [VideoTab(), NotesTab(), QuizTab()]),
        ),
      ),
    );
  }
}
