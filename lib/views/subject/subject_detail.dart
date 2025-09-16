import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/subject_detail_controller.dart';
import 'package:entrance_tricks/controllers/payment_controller.dart';
import 'package:entrance_tricks/models/models.dart';

class SubjectDetail extends StatelessWidget {
  SubjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubjectDetailController());

    return GetBuilder<SubjectDetailController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar with Back Arrow and Subject Name
              _buildTopBar(context, controller),

              // Payment Status Section (if subject is paid)
              // _buildPaymentStatusSection(
              //   context,
              //   controller,
              //   paymentController,
              // ),

              // Chapter List Section
              Expanded(child: _buildChapterList(context, controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    SubjectDetailController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Arrow
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8),

              child: Icon(Icons.arrow_back, color: Colors.blue, size: 20),
            ),
          ),

          SizedBox(width: 16),

          // Subject Name
          Text(
            controller.subjectName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPaymentStatusSection(
  //   BuildContext context,
  //   SubjectDetailController controller,
  //   PaymentController paymentController,
  // ) {
  //   // This would need to be implemented based on the subject's payment status
  //   // For now, return empty container - in real implementation, you'd check if subject requires payment
  //   return FutureBuilder<Payment?>(
  //     future: paymentController.getSubjectPackageInfo(controller.subjectId),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return SizedBox.shrink();

  //       final paymentInfo = snapshot.data!;
  //       final bool isPaid = paymentInfo['isPaid'] ?? false;

  //       if (!isPaid) return SizedBox.shrink();

  //       final int price = paymentInfo['price'] ?? 0;

  //       return FutureBuilder<Payment?>(
  //         future: paymentController.checkPayment(controller.subjectId),
  //         builder: (context, accessSnapshot) {
  //           if (!accessSnapshot.hasData) {
  //             return Container(
  //               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //               padding: EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: Colors.orange.shade50,
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(color: Colors.orange.shade200),
  //               ),
  //               child: Row(
  //                 children: [
  //                   CircularProgressIndicator(strokeWidth: 2),
  //                   SizedBox(width: 12),
  //                   Text('Checking payment status...'),
  //                 ],
  //               ),
  //             );
  //           }

  //           final accessResponse = accessSnapshot.data!;

  //           if (accessResponse.hasAccess) {
  //             return Container(
  //               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //               padding: EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: Colors.green.shade50,
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(color: Colors.green.shade200),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.check_circle, color: Colors.green.shade700),
  //                   SizedBox(width: 12),
  //                   Expanded(
  //                     child: Text(
  //                       'Payment approved - You have full access',
  //                       style: TextStyle(
  //                         color: Colors.green.shade700,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           } else {
  //             return Container(
  //               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //               padding: EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: Colors.red.shade50,
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(color: Colors.red.shade200),
  //               ),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Icon(Icons.payment, color: Colors.red.shade700),
  //                       SizedBox(width: 12),
  //                       Expanded(
  //                         child: Text(
  //                           'Payment required - $price ETB',
  //                           style: TextStyle(
  //                             color: Colors.red.shade700,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 12),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: ElevatedButton(
  //                       onPressed: () => _navigateToPayment(
  //                         context,
  //                         controller.subjectId,
  //                         price,
  //                         paymentInfo['title'] ?? 'Subject',
  //                       ),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Theme.of(context).primaryColor,
  //                         foregroundColor: Colors.white,
  //                       ),
  //                       child: Text('Make Payment'),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildChapterList(
    BuildContext context,
    SubjectDetailController controller,
  ) {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Chapters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: controller.chapters.length,
              itemBuilder: (context, index) {
                final chapter = controller.chapters[index];
                return _buildChapterCard(context, chapter, index, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    Chapter chapter,
    int index,
    SubjectDetailController controller,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            // Chapter Number Circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (chapter.chapterNumber).toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 20),

            // Chapter Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    chapter.description ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            SizedBox(width: 16),

            // Lock/Unlock Icon
            GestureDetector(
              onTap: () {
                if (controller.isLocked) {
                  _showLockedDialog(context);
                } else {
                  controller.openChapter(chapter.id);
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: controller.isLocked
                        ? Colors.grey.shade200
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    controller.isLocked ? Icons.lock : Icons.lock_open,
                    color: controller.isLocked
                        ? Colors.grey.shade600
                        : Colors.blue.shade700,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    final paymentController = Get.find<PaymentController>();
    final subjectController = Get.find<SubjectDetailController>();

    // Get subject payment info
    paymentController.getSubjectPackageInfo(subjectController.subjectId).then((
      paymentInfo,
    ) {
      final price = paymentInfo?['price'] ?? 0;
      final title = paymentInfo?['title'] ?? 'Subject';

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Content Is Locked',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'This content requires payment to access. Please make a payment of $price ETB to unlock all chapters.',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        _navigateToPayment(
                          context,
                          subjectController.subjectId,
                          price,
                          title,
                        );
                      },
                      icon: Icon(Icons.payment),
                      label: Text('Make Payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    });
  }

  void _navigateToPayment(
    BuildContext context,
    int subjectId,
    int amount,
    String subjectTitle,
  ) {
    Get.toNamed(
      '/payment/methods',
      arguments: {
        'subjectId': subjectId,
        'amount': amount,
        'subjectTitle': subjectTitle,
      },
    );
  }
}
