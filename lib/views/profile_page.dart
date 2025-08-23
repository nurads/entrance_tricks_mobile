import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/profile_controller.dart';
import 'package:entrance_tricks/components/components.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => controller.editProfile(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    ProfileAvatar(
                      name: controller.user['name'] ?? 'User Name',
                      size: 100,
                      isOnline: true,
                      onTap: () => controller.editProfile(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      controller.user['name'] ?? 'User Name',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    CustomBadge(
                      text: controller.user['phone'] ?? '+95 9xxxxxxxxx',
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant,
                      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.quiz_outlined,
                      title: 'Total Exams',
                      value: controller.user['totalExams']?.toString() ?? '0',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      icon: Icons.grade_outlined,
                      title: 'Avg Score',
                      value: '${controller.user['averageScore'] ?? 0}%',
                      iconColor: Theme.of(context).colorScheme.secondary,
                      valueColor: Theme.of(context).colorScheme.secondary,
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              StatCard(
                icon: Icons.video_library_outlined,
                title: 'Videos Watched',
                value: controller.user['videosWatched']?.toString() ?? '0',
                subtitle: 'Keep learning to unlock more content',
                iconColor: Theme.of(context).colorScheme.tertiary,
                valueColor: Theme.of(context).colorScheme.tertiary,
                onTap: () {},
              ),

              SizedBox(height: 24),

              // Settings Section
              CustomCard(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    ActionListTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      subtitle: 'App preferences and configuration',
                      onTap: () => controller.openSettings(),
                    ),
                    Divider(height: 1),
                    ActionListTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: () => controller.openSupport(),
                    ),
                    Divider(height: 1),
                    ActionListTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App version and information',
                      onTap: () => controller.openAbout(),
                    ),
                    Divider(height: 1),
                    ActionListTile(
                      icon: Icons.logout_outlined,
                      title: 'Logout',
                      subtitle: 'Sign out of your account',
                      iconColor: Theme.of(context).colorScheme.error,
                      showArrow: false,
                      onTap: () => controller.logout(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
