import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/subject_controller.dart';
import 'package:entrance_tricks/models/models.dart';

class SubjectPage extends StatelessWidget {
  SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubjectController());
    return GetBuilder<SubjectController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar with Back Arrow and Grade Name
              _buildTopBar(context, controller),

              // Subject List Section
              Expanded(child: _buildSubjectList(context, controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, SubjectController controller) {
    final gradeId = Get.arguments?['gradeId'] ?? 9;
    final gradeName = 'Grade $gradeId';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Arrow
          GestureDetector(
            onTap: () => Get.back(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),

          SizedBox(width: 16),

          // Grade Name
          Text(
            gradeName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectList(BuildContext context, SubjectController controller) {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose List of subjects',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.subjects.length,
              itemBuilder: (context, index) {
                final subject = controller.subjects[index];
                return _buildSubjectCard(context, subject, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    Subject subject,
    SubjectController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.navigateToSubjectDetail(subject.id),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Subject Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getSubjectIconColor(subject.title),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getSubjectIcon(subject.title),
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),

                // Subject Name
                Text(
                  subject.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Chapters Count
                Text(
                  '${subject.chapters?.length ?? 0} Chapters',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getSubjectIconColor(String subjectName) {
    switch (subjectName.toLowerCase()) {
      case 'english':
        return Colors.orange;
      case 'maths':
      case 'mathematics':
        return Colors.green;
      case 'physics':
        return Colors.blue;
      case 'chemistry':
        return Colors.green.shade600;
      case 'biology':
        return Colors.teal;
      case 'geography':
        return Colors.green.shade700;
      case 'history':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  IconData _getSubjectIcon(String subjectName) {
    switch (subjectName.toLowerCase()) {
      case 'english':
        return Icons.language;
      case 'maths':
      case 'mathematics':
        return Icons.calculate;
      case 'physics':
        return Icons.science;
      case 'chemistry':
        return Icons.science_outlined;
      case 'biology':
        return Icons.eco;
      case 'geography':
        return Icons.map;
      case 'history':
        return Icons.history_edu;
      default:
        return Icons.book;
    }
  }
}
