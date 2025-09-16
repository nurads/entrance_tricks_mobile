import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/profile_controller.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) => SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              // _buildProfilePictureSection(controller),
              SizedBox(height: 30),

              // Profile Information
              Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),

              _buildProfileField(
                context,
                Icons.person_outline,
                "Full Name",
                (value) => controller.updateUserName(value),
                controller.nameEditController,
              ),

              SizedBox(height: 20),

              _buildGradeDropdown(context, controller),

              SizedBox(height: 20),

              _buildProfileField(
                context,
                Icons.phone_outlined,
                "Phone Number",
                (value) => controller.updateUserPhone(value),
                controller.phoneEditController,
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.hasChangeOnEditProfile
                          ? controller.updateUserOnSave
                          : null,
                      // onPressed: () => controller.updateUserOnSave(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isUpdating
                          ? CircularProgressIndicator()
                          : Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildProfilePictureSection(ProfileController controller) {
  //   return Center(
  //     child: Column(
  //       children: [
  //         Stack(
  //           children: [
  //             Container(
  //               width: 120,
  //               height: 120,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 border: Border.all(color: Colors.blue[300]!, width: 4),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.blue.withValues(alpha: 0.2),
  //                     blurRadius: 20,
  //                     offset: Offset(0, 8),
  //                   ),
  //                 ],
  //               ),
  //               child: ClipOval(
  //                 child: Container(
  //                   color: Colors.grey[200],
  //                   child: Icon(
  //                     Icons.person,
  //                     size: 60,
  //                     color: Colors.grey[600],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: 0,
  //               right: 0,
  //               child: Container(
  //                 width: 36,
  //                 height: 36,
  //                 decoration: BoxDecoration(
  //                   color: Colors.blue[600],
  //                   shape: BoxShape.circle,
  //                   border: Border.all(color: Colors.white, width: 3),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withValues(alpha: 0.2),
  //                       blurRadius: 8,
  //                       offset: Offset(0, 2),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12),
  //         Text(
  //           'Tap to change photo',
  //           style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProfileField(
    BuildContext context,
    IconData icon,
    String label,
    Function(String) onChanged,
    TextEditingController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 20),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextField(
            controller: controller,
            onSubmitted: onChanged,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDropdown(
    BuildContext context,
    ProfileController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined, color: Colors.grey[600], size: 20),
              SizedBox(width: 12),
              Text(
                "Class/Grade",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: controller.selectedGrade?.id,

            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            hint: Text(
              'Select Grade',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            items: controller.availableGrades.map((Grade grade) {
              return DropdownMenuItem<int>(
                value: grade.id,
                child: Text(
                  grade.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              controller.updateSelectedGrade(newValue);
            },
          ),
        ],
      ),
    );
  }

  void _saveProfile(ProfileController controller) {
    // TODO: Implement save profile functionality
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.back();
  }
}
