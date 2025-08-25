import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/home_dashboard_controller.dart';
import 'package:entrance_tricks/controllers/navigation_drawer_controller.dart';
import 'package:entrance_tricks/controllers/notifications_controller.dart';
import 'package:entrance_tricks/views/notifications_page.dart';

class HomeDashboard extends StatelessWidget {
  HomeDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeDashboardController());
    Get.put(NavigationDrawerController());
    Get.put(NotificationsController());
    
    return GetBuilder<HomeDashboardController>(
      builder: (controller) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: _buildNavigationDrawer(context),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar with Hamburger Menu and Notification Bell
              _buildTopBar(context, controller),
              
              // Search Bar
              _buildSearchBar(context),
              
              // Promotional Banner
              _buildPromotionalBanner(context),
              
              // Grade Selection Section
              Expanded(
                child: _buildGradeSelection(context, controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, HomeDashboardController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Hamburger Menu
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.black87),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            mouseCursor: SystemMouseCursors.click,
          ),
          
          Spacer(),
          
          // Notification Bell with Badge
          GetBuilder<NotificationsController>(
            builder: (notificationsController) => Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => NotificationsPage());
                  },
                  icon: Icon(Icons.notifications_outlined, color: Colors.black87),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  mouseCursor: SystemMouseCursors.click,
                ),
                if (notificationsController.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${notificationsController.unreadCount > 9 ? "9+" : notificationsController.unreadCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search..',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entrance Tricks!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'For HighSchool Class',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement contact us functionality
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Contact us',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Illustration placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSelection(BuildContext context, HomeDashboardController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What Grade Are You?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: controller.grades.length,
              itemBuilder: (context, index) {
                final grade = controller.grades[index];
                return _buildGradeCard(context, grade, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeCard(BuildContext context, Map<String, dynamic> grade, HomeDashboardController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.selectGrade(grade['id']),
          borderRadius: BorderRadius.circular(16),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Grade Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getGradeIconColor(grade['name']),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getGradeIcon(grade['name']),
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(width: 20),
                
                // Grade Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        grade['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${grade['subjects']} Subjects • ${grade['chapters']} Chapters',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  Color _getGradeIconColor(String gradeName) {
    switch (gradeName.toLowerCase()) {
      case 'grade 6':
        return Colors.red;
      case 'grade 8':
        return Colors.black87;
      case 'grade 9':
        return Colors.orange;
      case 'grade 10':
        return Colors.red;
      case 'grade 11':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getGradeIcon(String gradeName) {
    switch (gradeName.toLowerCase()) {
      case 'grade 6':
        return Icons.book;
      case 'grade 8':
        return Icons.library_books;
      case 'grade 9':
        return Icons.library_books;
      case 'grade 10':
        return Icons.library_books;
      case 'grade 11':
        return Icons.library_books;
      default:
        return Icons.school;
    }
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue[600],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo Image
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Welcome Message
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  
                  SizedBox(height: 4),
                  
                  Text(
                    'William Huffman', // mock until backend wiring
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Drawer Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerMenuItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    onTap: () {
                      Get.find<NavigationDrawerController>().navigateToFAQ();
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.headset,
                    title: 'Support',
                    onTap: () {
                      Get.find<NavigationDrawerController>().navigateToSupport();
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.location_on,
                    title: 'About',
                    onTap: () {
                      Get.find<NavigationDrawerController>().navigateToAbout();
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.person,
                    title: 'Contact Us',
                    onTap: () {
                      Get.find<NavigationDrawerController>().navigateToContactUs();
                    },
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  _buildDrawerMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      Get.find<NavigationDrawerController>().logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[700],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
