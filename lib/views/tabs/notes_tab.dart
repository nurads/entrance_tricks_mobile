import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';

class NotesTab extends StatelessWidget {
  NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notes Content
              _buildNotesContent(context),
              
              Spacer(),
              
              // Download Notes Button
              _buildDownloadButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotesContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit 1: Physics and Human Society (Ethiopia)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        SizedBox(height: 24),
        
        // Definition & Scope Section
        _buildNotesSection(
          context,
          'Definition & Scope',
          'Physics is the study of matter, energy, and their interaction. It explores the fundamental principles that govern the natural world and provides the foundation for understanding how things work in our daily lives.',
        ),
        
        SizedBox(height: 20),
        
        // Branches & Connections Section
        _buildNotesSection(
          context,
          'Branches & Connections',
          'Physics encompasses various branches including mechanics, thermodynamics, electromagnetism, and quantum physics. It has historical development and strong connections to other scientific fields.',
        ),
        
        SizedBox(height: 20),
        
        // Social Importance Section
        _buildNotesSection(
          context,
          'Social Importance',
          'Physics plays a crucial role in transportation, medical science, communication technologies, and environmental studies. It helps us understand and improve the world around us.',
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
        
        SizedBox(height: 8),
        
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _downloadNotes(),
        icon: Icon(Icons.download, color: Colors.white),
        label: Text(
          'Download notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _downloadNotes() {
    Get.snackbar('Info', 'Notes download will be implemented');
  }
}
