import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/home_dashboard_controller.dart';
import 'package:entrance_tricks/components/components.dart';

class HomeDashboard extends StatelessWidget {
  HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeDashboardController());
    return GetBuilder<HomeDashboardController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Entrance Tricks'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => controller.showSearch(),
            ),
            NotificationBadge(
              child: IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () => controller.openNotifications(),
              ),
              count: controller.notificationCount,
            ),
            SizedBox(width: 8),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Banner
                _buildWelcomeBanner(context, controller),

                SizedBox(height: 24),

                // Quick Stats
                _buildQuickStats(context, controller),

                SizedBox(height: 24),

                // Recent Exams Section
                _buildSectionHeader(
                  context,
                  'Recent Exams',
                  'View All',
                  () => controller.viewAllExams(),
                ),
                SizedBox(height: 12),
                _buildRecentExams(context, controller),

                SizedBox(height: 24),

                // Recent News Section
                _buildSectionHeader(
                  context,
                  'Latest News',
                  'View All',
                  () => controller.viewAllNews(),
                ),
                SizedBox(height: 12),
                _buildRecentNews(context, controller),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(
    BuildContext context,
    HomeDashboardController controller,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      controller.userName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Continue your learning journey',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.school, size: 40, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.startLearning(),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start Learning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    HomeDashboardController controller,
  ) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.trending_up,
            title: 'Study Streak',
            value: '${controller.studyStreak}',
            subtitle: 'days',
            iconColor: Theme.of(context).colorScheme.secondary,
            valueColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: Icons.assignment_turned_in,
            title: 'Completed',
            value: '${controller.completedExams}',
            subtitle: 'exams',
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
    VoidCallback onAction,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        TextButton(onPressed: onAction, child: Text(actionText)),
      ],
    );
  }

  Widget _buildRecentExams(
    BuildContext context,
    HomeDashboardController controller,
  ) {
    if (controller.isLoading) {
      return Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonCard(height: 120),
          ),
        ),
      );
    }

    return Column(
      children: controller.recentExams.map((exam) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: CustomCard(
            onTap: () => controller.openExam(exam['id']),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.quiz_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam['title'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${exam['questions']} Questions • ${exam['duration']} mins',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          StatusBadge(
                            text: exam['status'],
                            status: exam['status'] == 'Completed'
                                ? BadgeStatus.success
                                : BadgeStatus.info,
                          ),
                          if (exam['score'] != null) ...[
                            SizedBox(width: 8),
                            Text(
                              'Score: ${exam['score']}%',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentNews(
    BuildContext context,
    HomeDashboardController controller,
  ) {
    if (controller.isLoading) {
      return Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonCard(height: 100),
          ),
        ),
      );
    }

    return Column(
      children: controller.recentNews.map((news) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: CustomCard(
            onTap: () => controller.openNews(news['id']),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.article_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news['title'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        news['excerpt'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        news['date'],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
