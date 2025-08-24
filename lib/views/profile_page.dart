import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Blue Header with Wave
            _buildHeader(context, controller),
            
            // Profile Picture
            _buildProfilePicture(context, controller),
            
            // Profile Content
            Expanded(
              child: _buildProfileContent(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileController controller) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue[600],
      ),
      child: Stack(
        children: [
          // Header Content
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button (only visible in edit mode)
                if (controller.isEditMode)
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      child: GestureDetector(
                        onTap: () => controller.toggleEditMode(),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(width: 44),
                
                // Title
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                // Edit Button
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.precise,
                    child: GestureDetector(
                      onTap: () => controller.toggleEditMode(),
                      child: Icon(
                        controller.isEditMode ? Icons.check : Icons.edit,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Wave Separator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: WavePainter(),
              size: Size(double.infinity, 60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context, ProfileController controller) {
    return Transform.translate(
      offset: Offset(0, -50),
      child: Center(
        child: Stack(
          children: [
            // Profile Picture
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  controller.profileImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Edit Icon (only visible in edit mode)
            if (controller.isEditMode)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 60), // Space for profile picture
          
          // Profile Fields
          _buildProfileField(
            context,
            Icons.person,
            "Name",
            controller.userName,
            controller.isEditMode,
            (value) => controller.updateUserName(value),
          ),
          
          SizedBox(height: 24),
          
          _buildProfileField(
            context,
            Icons.business,
            "Class",
            controller.userClass,
            controller.isEditMode,
            (value) => controller.updateUserClass(value),
          ),
          
          SizedBox(height: 24),
          
          _buildProfileField(
            context,
            Icons.phone,
            "Phone no.",
            controller.userPhone,
            controller.isEditMode,
            (value) => controller.updateUserPhone(value),
          ),
          
          SizedBox(height: 40),
          
          // Additional Actions
          if (!controller.isEditMode) ...[
            _buildActionButton(
              context,
              Icons.settings,
              "Settings",
              () {
                // TODO: Navigate to settings
              },
            ),
            
            SizedBox(height: 16),
            
            _buildActionButton(
              context,
              Icons.help,
              "Help & Support",
              () {
                // TODO: Navigate to help
              },
            ),
            
            SizedBox(height: 16),
            
            _buildActionButton(
              context,
              Icons.logout,
              "Logout",
              () {
                // TODO: Implement logout
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileField(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isEditMode,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.black87,
              size: 20,
            ),
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
        
        SizedBox(height: 8),
        
        if (isEditMode)
          TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue[600]!),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey[700],
                size: 20,
              ),
              SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[500],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for wave effect
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
