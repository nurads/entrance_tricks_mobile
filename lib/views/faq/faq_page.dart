import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How do I create an account?',
      answer: 'To create an account, tap on the "Register" button on the login screen. Enter your phone number and follow the verification process. You\'ll receive an OTP to verify your number.',
    ),
    FAQItem(
      question: 'How do I access premium content?',
      answer: 'Premium content requires a subscription. Go to the Payment page from the drawer menu, select a package, and complete the payment process. Once approved, you\'ll have access to all premium features.',
    ),
    FAQItem(
      question: 'Can I download content for offline use?',
      answer: 'Yes! You can download videos, notes, and exams for offline access. Go to the Downloads page to manage your offline content. Downloaded content will be available even without an internet connection.',
    ),
    FAQItem(
      question: 'How do I take practice exams?',
      answer: 'Navigate to the Exams section from the bottom navigation or drawer menu. Select an exam you want to take, review the instructions, and start the exam. You can pause and resume as needed.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer: 'We accept various payment methods including bank transfers, mobile banking, and digital wallets. All payment methods are listed in the payment page with their respective account details.',
    ),
    FAQItem(
      question: 'How long does payment approval take?',
      answer: 'Payment approval typically takes 24-48 hours after you submit your receipt. You\'ll receive a notification once your payment is approved and your subscription is activated.',
    ),
    FAQItem(
      question: 'Can I change my subscription plan?',
      answer: 'Yes, you can upgrade your subscription plan at any time. Contact our support team or go to the Payment page to select a new package. The new plan will be activated after payment approval.',
    ),
    FAQItem(
      question: 'How do I track my progress?',
      answer: 'Your progress is automatically tracked as you complete lessons, take exams, and study materials. You can view your progress in the Profile section and on individual subject pages.',
    ),
    FAQItem(
      question: 'What if I forget my password?',
      answer: 'If you forget your password, use the "Forgot Password" option on the login screen. Enter your registered phone number and follow the instructions to reset your password.',
    ),
    FAQItem(
      question: 'Is there a mobile app available?',
      answer: 'Yes! You\'re currently using our mobile app. The app is available for both Android and iOS devices and provides the same features as our web platform with additional mobile-specific benefits.',
    ),
    FAQItem(
      question: 'How do I contact support?',
      answer: 'You can contact our support team through multiple channels: Telegram (@entrance_tricks_support), email (support@entrancetricks.com), or phone (+251 911 234 567). We typically respond within 24 hours.',
    ),
    FAQItem(
      question: 'Can I share my account with others?',
      answer: 'No, account sharing is not allowed. Each subscription is for individual use only. Sharing accounts may result in suspension of your access. We recommend each student to have their own account.',
    ),
    FAQItem(
      question: 'What subjects are available?',
      answer: 'We cover all major subjects for entrance examinations including Mathematics, Physics, Chemistry, Biology, English, and more. New subjects and content are added regularly based on curriculum updates.',
    ),
    FAQItem(
      question: 'How often is content updated?',
      answer: 'Our content is regularly updated to reflect the latest curriculum changes and exam patterns. We add new videos, practice tests, and study materials on a weekly basis.',
    ),
    FAQItem(
      question: 'Can I get a refund?',
      answer: 'Refunds are considered on a case-by-case basis. If you experience technical issues or are not satisfied with the service, please contact our support team within 7 days of your subscription activation.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Expanded(child: _buildFAQContent(context)),
            ],
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
                  'FAQ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Frequently Asked Questions',
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

          // Search Button
          GestureDetector(
            onTap: () => _showSearchDialog(),
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
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Quick Help Card
          _buildQuickHelpCard(),
          
          const SizedBox(height: 24),
          
          // FAQ List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return _buildFAQItem(faqItems[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHelpCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Quick Help',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Can\'t find what you\'re looking for? Contact our support team for personalized assistance.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.telegram,
                  label: 'Telegram',
                  color: const Color(0xFF0088cc),
                  onTap: () => _launchTelegram(),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  color: const Color(0xFFEA4335),
                  onTap: () => _launchEmail(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFF667eea),
              size: 18,
            ),
          ),
          title: Text(
            item.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          children: [
            Text(
              item.answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search FAQ'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search for questions...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            // Implement search functionality
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _launchTelegram() async {
    Get.snackbar(
      'Info',
      'Opening Telegram support...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _launchEmail() async {
    Get.snackbar(
      'Info',
      'Opening email app...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
