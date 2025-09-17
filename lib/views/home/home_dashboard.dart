import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/home_dashboard_controller.dart';
import 'package:entrance_tricks/controllers/navigation_drawer_controller.dart';
import 'package:entrance_tricks/controllers/notifications_controller.dart';
import 'package:entrance_tricks/views/common/notifications_page.dart';
import "package:entrance_tricks/models/models.dart";
import "package:entrance_tricks/utils/utils.dart";
import "package:entrance_tricks/services/services.dart";
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/controllers/main_navigation_controller.dart';

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
              // _buildSearchBar(context),

              // Promotional Banner
              _buildPromotionalBanner(context),

              // Grade Selection Section
              // Expanded(child: _buildGradeSelection(context, controller)),
              Expanded(child: _buildSubjectSelection(context, controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    HomeDashboardController controller,
  ) {
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
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.black87,
                  ),
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

  // Widget _buildSearchBar(BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         hintText: 'Search..',
  //         hintStyle: TextStyle(color: Colors.grey[600]),
  //         prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
  //         filled: true,
  //         fillColor: Colors.grey[100],
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(25),
  //           borderSide: BorderSide.none,
  //         ),
  //         contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //       ),
  //     ),
  //   );
  // }

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
                    color: Colors.white.withValues(alpha: 0.9),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelection(
    BuildContext context,
    HomeDashboardController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject Selection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: controller.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading subjects...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
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

  // Widget _buildGradeSelection(
  //   BuildContext context,
  //   HomeDashboardController controller,
  // ) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'What Grade Are You?',
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         SizedBox(height: 20),
  //         Expanded(
  //           child: ListView.builder(
  //             physics: BouncingScrollPhysics(),
  //             itemCount: controller.grades.length,
  //             itemBuilder: (context, index) {
  //               final grade = controller.grades[index];
  //               return _buildSubjectCard(context, grade, controller);
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSubjectCard(
    BuildContext context,
    Subject subject,
    HomeDashboardController controller,
  ) {
    final isLocked = subject.isLocked;
    final totalChapters = subject.chapters.length;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.selectSubject(subject.id),
          borderRadius: BorderRadius.circular(20),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey[50] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isLocked
                      ? Colors.grey.withValues(alpha: 0.3)
                      : _getGradeIconColor(subject.name).withValues(alpha: 0.2),
                  width: isLocked ? 1 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isLocked
                        ? Colors.grey.withValues(alpha: 0.05)
                        : _getGradeIconColor(
                            subject.name,
                          ).withValues(alpha: 0.1),
                    blurRadius: isLocked ? 5 : 15,
                    offset: Offset(0, isLocked ? 2 : 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Enhanced Grade Icon with Lock Overlay
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey[300]
                              : _getGradeIconColor(subject.name),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isLocked
                                  ? Colors.grey.withValues(alpha: 0.2)
                                  : _getGradeIconColor(
                                      subject.name,
                                    ).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: subject.icon != null && subject.icon!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  subject.icon!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    logger.e(error);
                                    return Icon(
                                      _getGradeIcon(subject.name),
                                      size: 30,
                                      color: isLocked
                                          ? Colors.grey[600]
                                          : Colors.white,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  isLocked
                                                      ? Colors.grey[600]!
                                                      : Colors.white,
                                                ),
                                          ),
                                        );
                                      },
                                ),
                              )
                            : Icon(
                                _getGradeIcon(subject.name),
                                size: 30,
                                color: isLocked
                                    ? Colors.grey[600]
                                    : Colors.white,
                              ),
                      ),
                      // Lock Icon Overlay
                      if (isLocked)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.lock,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: 16),

                  // Enhanced Content Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject Name with Lock Status
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subject.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked
                                      ? Colors.grey[600]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (isLocked)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Locked',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange[700],
                                  ),
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 6),

                        // Description (if available)
                        if (subject.description != null &&
                            subject.description!.isNotEmpty)
                          Text(
                            subject.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: isLocked
                                  ? Colors.grey[500]
                                  : Colors.grey[600],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                        SizedBox(height: 8),

                        // Chapter Information
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 16,
                              color: isLocked
                                  ? Colors.grey[400]
                                  : _getGradeIconColor(subject.name),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '$totalChapters Chapters',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isLocked
                                    ? Colors.grey[500]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isLocked
                        ? Colors.grey[400]
                        : _getGradeIconColor(subject.name),
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

  // Helper method to format dates

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
    final _coreService = Get.find<CoreService>();
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: Column(
          children: [
            // Modern Drawer Header (Reduced - No Logo)
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[600]!, Colors.blue[800]!],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info with modern styling
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _coreService.authService.user.value?.firstName ??
                              'User',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          _coreService.authService.user.value?.phoneNumber ??
                              '',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Drawer Menu Items with sections
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: [
                  // Main Navigation Section
                  _buildSectionHeader('Main Navigation'),
                  _buildModernDrawerMenuItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    subtitle: 'Dashboard & Overview',
                    onTap: () {
                      Get.find<MainNavigationController>().changeIndex(0);
                    },
                    isSelected:
                        Get.find<MainNavigationController>().currentIndex == 0,
                  ),
                  _buildModernDrawerMenuItem(
                    icon: Icons.quiz_rounded,
                    title: 'Exams',
                    subtitle: 'Practice & Mock Tests',
                    onTap: () {
                      Get.find<MainNavigationController>().changeIndex(1);
                    },
                    isSelected:
                        Get.find<MainNavigationController>().currentIndex == 1,
                  ),
                  _buildModernDrawerMenuItem(
                    icon: Icons.article_rounded,
                    title: 'News',
                    subtitle: 'Latest Updates',
                    onTap: () {
                      Get.find<MainNavigationController>().changeIndex(2);
                    },
                    isSelected:
                        Get.find<MainNavigationController>().currentIndex == 2,
                  ),
                  _buildModernDrawerMenuItem(
                    icon: Icons.person_rounded,
                    title: 'Profile',
                    subtitle: 'Account & Settings',
                    onTap: () {
                      Get.find<MainNavigationController>().changeIndex(3);
                    },
                    isSelected:
                        Get.find<MainNavigationController>().currentIndex == 3,
                  ),

                  SizedBox(height: 20),

                  // Study Materials Section
                  _buildSectionHeader('Study Materials'),
                  _buildModernDrawerMenuItem(
                    icon: Icons.book_rounded,
                    title: 'Subjects',
                    subtitle: 'Browse all subjects',
                    onTap: () => Get.toNamed(VIEWS.subjects.path),
                  ),

                  SizedBox(height: 20),

                  // Tools & Features Section
                  _buildSectionHeader('Tools & Features'),

                  _buildModernDrawerMenuItem(
                    icon: Icons.download_rounded,
                    title: 'Downloads',
                    subtitle: 'Offline content',
                    onTap: () => Get.toNamed(VIEWS.downloads.path),
                  ),

                  SizedBox(height: 20),

                  // Payment & Account Section
                  _buildSectionHeader('Account & Payment'),
                  _buildModernDrawerMenuItem(
                    icon: Icons.payment_rounded,
                    title: 'Payment',
                    subtitle: 'Manage subscription',
                    onTap: () => Get.toNamed(VIEWS.payment.path),
                  ),
                  _buildModernDrawerMenuItem(
                    icon: Icons.history_rounded,
                    title: 'Payment History',
                    subtitle: 'View transactions',
                    onTap: () => Get.toNamed(VIEWS.paymentHistory.path),
                  ),

                  SizedBox(height: 20),

                  // Support Section
                  _buildSectionHeader('Support'),
                  _buildModernDrawerMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    onTap: () => Get.toNamed(VIEWS.faq.path),
                  ),
                  _buildModernDrawerMenuItem(
                    icon: Icons.headset_mic_rounded,
                    title: 'Support',
                    subtitle: 'Get help & support',
                    onTap: () => Get.toNamed(VIEWS.support.path),
                  ),
                  _buildModernDrawerMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    subtitle: 'App information',
                    onTap: () => Get.toNamed(VIEWS.about.path),
                  ),

                  SizedBox(height: 20),

                  // Logout Section
                  _buildModernDrawerMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    onTap: () {
                      Get.find<NavigationDrawerController>().logout();
                    },
                    isDestructive: true,
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildModernDrawerMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Colors.blue.withOpacity(0.3), width: 1)
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.1)
                : isSelected
                ? Colors.blue.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive
                ? Colors.red[600]
                : isSelected
                ? Colors.blue[600]
                : Colors.grey[600],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isDestructive
                ? Colors.red[600]
                : isSelected
                ? Colors.blue[600]
                : Colors.grey[800],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: isSelected
            ? Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.check, color: Colors.white, size: 12),
              )
            : Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 14,
              ),
        onTap: onTap,
      ),
    );
  }
}
