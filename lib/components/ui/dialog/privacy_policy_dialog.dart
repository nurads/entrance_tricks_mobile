import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  static void show() {
    Get.dialog(
      const PrivacyPolicyDialog(),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Privacy Policy',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      context,
                      '1. Information We Collect',
                      'We collect information that you provide directly to us, such as when you create an account, update your profile, or use our services. This may include your name, phone number, email address, and academic information.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '2. How We Use Your Information',
                      'We use the information we collect to provide, maintain, and improve our services, process transactions, send you notifications, and personalize your experience.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '3. Information Sharing',
                      'We do not sell, trade, or rent your personal information to third parties. We may share your information only with your consent or as required by law.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '4. Data Security',
                      'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '5. Your Rights',
                      'You have the right to access, update, or delete your personal information at any time through your account settings or by contacting us directly.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '6. Cookies and Tracking',
                      'We may use cookies and similar tracking technologies to track activity on our application and hold certain information to improve your experience.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '7. Children\'s Privacy',
                      'Our services are not intended for children under the age of 13. We do not knowingly collect personal information from children under 13.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '8. Changes to This Policy',
                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      '9. Contact Us',
                      'If you have any questions about this Privacy Policy, please contact us through the support section of the application.',
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

