import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/subject_detail_controller.dart';

class SubjectDetail extends StatelessWidget {
  SubjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubjectDetailController());
    return GetBuilder<SubjectDetailController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(controller.subjectName),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: controller.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = controller.chapters[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        chapter['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${chapter['videos']} Videos • ${chapter['notes']} Notes • ${chapter['quizzes']} Quizzes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter['description'],
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          controller.openChapter(chapter['id']),
                                      icon: Icon(Icons.play_arrow),
                                      label: Text('Start Learning'),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: chapter['isCompleted']
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      chapter['isCompleted']
                                          ? 'Completed'
                                          : 'In Progress',
                                      style: TextStyle(
                                        color: chapter['isCompleted']
                                            ? Colors.green
                                            : Colors.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
