import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_academy/controllers/subject/subject_detail_controller.dart';
import 'package:vector_academy/models/models.dart';

class SubjectDetail extends StatelessWidget {
  const SubjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubjectDetailController());

    return GetBuilder<SubjectDetailController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, controller),

              Expanded(child: _buildChapterList(context, controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    SubjectDetailController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8),

              child: Icon(Icons.arrow_back, color: Colors.blue, size: 20),
            ),
          ),

          SizedBox(width: 16),

          Text(
            controller.subjectName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList(
    BuildContext context,
    SubjectDetailController controller,
  ) {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Chapters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: controller.chapters.length,
              itemBuilder: (context, index) {
                final chapter = controller.chapters[index];
                return _buildChapterCard(context, chapter, index, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    Chapter chapter,
    int index,
    SubjectDetailController controller,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (chapter.chapterNumber).toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    chapter.description ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            SizedBox(width: 16),

            GestureDetector(
              onTap: () {
                if (controller.isLocked) {
                } else {
                  controller.openChapter(chapter.id);
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: controller.isLocked
                        ? Colors.grey.shade200
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    controller.isLocked ? Icons.lock : Icons.lock_open,
                    color: controller.isLocked
                        ? Colors.grey.shade600
                        : Colors.blue.shade700,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
