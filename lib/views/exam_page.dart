import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/exam_controller.dart';

class ExamPage extends StatelessWidget {
  ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ExamController());
    return GetBuilder<ExamController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Exams'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: controller.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.exams.length,
                itemBuilder: (context, index) {
                  final exam = controller.exams[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.quiz,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        exam['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration: ${exam['duration']} mins'),
                          Text('Questions: ${exam['questions']}'),
                          Text('Best Score: ${exam['bestScore']}%'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => controller.navigateToExamDetail(exam['id']),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
