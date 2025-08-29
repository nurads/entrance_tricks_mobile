import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailPage({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back Button
            _buildTopBar(context),
            
            // Article Content
            Expanded(
              child: _buildArticleContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
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
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          
          Spacer(),
          
          // Title
          Text(
            "News",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          Spacer(),
          
          // Placeholder for symmetry
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildArticleContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Title
            Text(
              news['title'] ?? 'Article Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Article Meta Info
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    news['category'] ?? 'Education',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                SizedBox(width: 12),
                
                Text(
                  news['timeAgo'] ?? '3 min ago',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Article Content
            Text(
              news['content'] ?? 'Article content will be displayed here...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.chat_bubble_outline,
                  'Comment',
                  () {
                    // TODO: Implement comment functionality
                  },
                ),
                _buildActionButton(
                  Icons.bookmark_border,
                  'Save',
                  () {
                    // TODO: Implement save functionality
                  },
                ),
                _buildActionButton(
                  Icons.share,
                  'Share',
                  () {
                    // TODO: Implement share functionality
                  },
                ),
              ],
            ),
            
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
