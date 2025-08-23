import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/subject_controller.dart';

class SubjectPage extends StatelessWidget {
  SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubjectController());
    return GetBuilder<SubjectController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Subjects'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: controller.isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.subjects.length,
                itemBuilder: (context, index) {
                  final subject = controller.subjects[index];
                  return Card(
                    child: InkWell(
                      onTap: () => controller.navigateToSubjectDetail(subject['id']),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.book,
                                size: 30,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              subject['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${subject['chapters']} Chapters',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${subject['videos']} Videos',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
