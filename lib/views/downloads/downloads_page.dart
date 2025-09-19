import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/controllers.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DownloadsController());
    return GetBuilder<DownloadsController>(
      builder: (controller) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildModernTopBar(context),
                _buildTabBar(context),
                Expanded(child: _buildTabContent(context, controller)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Modern Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Title with Modern Typography
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Downloads',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your offline content',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          // Storage Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storage_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '2.1 GB',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library_rounded, size: 20),
                SizedBox(width: 8),
                Text('Videos'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_rounded, size: 20),
                SizedBox(width: 8),
                Text('Exams'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description_rounded, size: 20),
                SizedBox(width: 8),
                Text('Notes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    DownloadsController controller,
  ) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: TabBarView(
        controller: _tabController,
        children: [
          _VideosTab(controller: controller),
          _ExamsTab(controller: controller),
          _NotesTab(controller: controller),
        ],
      ),
    );
  }
}

class _VideosTab extends StatelessWidget {
  final DownloadsController controller;

  const _VideosTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadsController>(
      builder: (controller) {
        if (controller.isLoadingVideos.value) {
          return _buildLoadingState('Loading videos...');
        }

        if (controller.downloadedVideos.isEmpty) {
          return _buildEmptyState(
            icon: Icons.video_library_outlined,
            title: 'No Downloaded Videos',
            subtitle: 'Download videos to watch them offline',
          );
        }

        return Container(
          margin: const EdgeInsets.all(24),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: controller.downloadedVideos.length,
            itemBuilder: (context, index) {
              final video = controller.downloadedVideos[index];
              return _buildVideoItem(context, video, controller, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildVideoItem(
    BuildContext context,
    dynamic video,
    DownloadsController controller,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.playVideo(video['id']),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Video Thumbnail
                        Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Video Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video['title'] ?? 'Video Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                video['subject'] ?? 'Subject',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${video['size'] ?? '0'} MB',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Actions
                        Column(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  controller.playVideo(video['id']),
                              icon: const Icon(
                                Icons.play_circle_outline_rounded,
                                color: Color(0xFF667eea),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.deleteVideo(video['id']),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, size: 60, color: Colors.white.withOpacity(0.6)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ExamsTab extends StatelessWidget {
  final DownloadsController controller;

  const _ExamsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadsController>(
      builder: (controller) {
        if (controller.isLoadingExams.value) {
          return _buildLoadingState('Loading exams...');
        }

        if (controller.downloadedExams.isEmpty) {
          return _buildEmptyState(
            icon: Icons.quiz_outlined,
            title: 'No Downloaded Exams',
            subtitle: 'Download exams to practice offline',
          );
        }

        return Container(
          margin: const EdgeInsets.all(24),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: controller.downloadedExams.length,
            itemBuilder: (context, index) {
              final exam = controller.downloadedExams[index];
              return _buildExamItem(context, exam, controller, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildExamItem(
    BuildContext context,
    dynamic exam,
    DownloadsController controller,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.startExam(exam['id']),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Exam Icon
                        Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.quiz_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Exam Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam['name'] ?? 'Exam Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                exam['subject'] ?? 'Subject',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${exam['duration'] ?? 0} min',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.help_outline_rounded,
                                    size: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${exam['questions'] ?? 0} questions',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Actions
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => controller.startExam(exam['id']),
                              icon: const Icon(
                                Icons.play_circle_outline_rounded,
                                color: Color(0xFFf093fb),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.deleteExam(exam['id']),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, size: 60, color: Colors.white.withOpacity(0.6)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotesTab extends StatelessWidget {
  final DownloadsController controller;

  const _NotesTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadsController>(
      builder: (controller) {
        if (controller.isLoadingNotes.value) {
          return _buildLoadingState('Loading notes...');
        }

        if (controller.downloadedNotes.isEmpty) {
          return _buildEmptyState(
            icon: Icons.description_outlined,
            title: 'No Downloaded Notes',
            subtitle: 'Download notes to read them offline',
          );
        }

        return Container(
          margin: const EdgeInsets.all(24),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: controller.downloadedNotes.length,
            itemBuilder: (context, index) {
              final note = controller.downloadedNotes[index];
              return _buildNoteItem(context, note, controller, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildNoteItem(
    BuildContext context,
    dynamic note,
    DownloadsController controller,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.openNote(note['id']),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Note Icon
                        Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _getFileTypeIcon(note['type'] ?? 'pdf'),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Note Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note['title'] ?? 'Note Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                note['subject'] ?? 'Subject',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getFileTypeColor(
                                        note['type'] ?? 'pdf',
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      (note['type'] ?? 'pdf').toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: _getFileTypeColor(
                                          note['type'] ?? 'pdf',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${note['size'] ?? '0'} MB',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Actions
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => controller.openNote(note['id']),
                              icon: const Icon(
                                Icons.open_in_new_rounded,
                                color: Color(0xFF4facfe),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.deleteNote(note['id']),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getFileTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'markdown':
      case 'md':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFE53E3E);
      case 'doc':
      case 'docx':
        return const Color(0xFF3182CE);
      case 'ppt':
      case 'pptx':
        return const Color(0xFFDD6B20);
      case 'markdown':
      case 'md':
        return const Color(0xFF805AD5);
      default:
        return const Color(0xFF718096);
    }
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, size: 60, color: Colors.white.withOpacity(0.6)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
