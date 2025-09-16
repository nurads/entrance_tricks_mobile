// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../controllers/payment_controller.dart';
// import '../models/models.dart';

// class PaymentHistoryScreen extends StatelessWidget {
//   const PaymentHistoryScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final PaymentController controller = Get.put(PaymentController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment History'),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: controller.loadUserPayments,
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoadingPayments.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.userPayments.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.payment, size: 64, color: Colors.grey.shade400),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No payments found',
//                   style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Your payment history will appear here',
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//                 ),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.loadUserPayments,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: controller.userPayments.length,
//             itemBuilder: (context, index) {
//               final payment = controller.userPayments[index];
//               return _buildPaymentCard(context, controller, payment);
//             },
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildPaymentCard(
//     BuildContext context,
//     PaymentController controller,
//     Payment payment,
//   ) {
//     final statusColor = controller.getPaymentStatusColor(payment.isCompleted);
//     final statusIcon = controller.getPaymentStatusIcon(payment.isCompleted);
//     final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with subject and status
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     payment.package?.name ?? 'Unknown Package',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: statusColor.withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(statusIcon, size: 16, color: statusColor),
//                       const SizedBox(width: 4),
//                       Text(
//                         payment.status.displayName,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: statusColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // Payment details
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDetailItem(
//                     'Amount',
//                     '${payment.amount} ETB',
//                     Icons.attach_money,
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildDetailItem(
//                     'Method',
//                     payment.paymentMethod?.name ?? 'N/A',
//                     Icons.account_balance,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             _buildDetailItem(
//               'Date',
//               dateFormat.format(DateTime.parse(payment.paymentDate)),
//               Icons.calendar_today,
//             ),

//             // Admin notes if rejected
//             if (payment.status == PaymentStatus.rejected &&
//                 payment.adminNotes != null &&
//                 payment.adminNotes!.isNotEmpty) ...[
//               const SizedBox(height: 12),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.red.shade200),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.info, size: 16, color: Colors.red.shade700),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Admin Notes',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red.shade700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       payment.adminNotes!,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.red.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],

//             // Approved date if approved
//             if (payment.status == PaymentStatus.approved &&
//                 payment.approvedAt != null) ...[
//               const SizedBox(height: 8),
//               _buildDetailItem(
//                 'Approved',
//                 dateFormat.format(DateTime.parse(payment.approvedAt!)),
//                 Icons.check_circle,
//                 color: Colors.green,
//               ),
//             ],

//             // Actions
//             if (payment.status == PaymentStatus.rejected) ...[
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton.icon(
//                   onPressed: () => _retryPayment(context, payment),
//                   icon: const Icon(Icons.refresh),
//                   label: const Text('Retry Payment'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailItem(
//     String label,
//     String value,
//     IconData icon, {
//     Color? color,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: color ?? Colors.grey.shade600),
//           const SizedBox(width: 8),
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Flexible(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: color ?? Colors.black87,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _retryPayment(BuildContext context, Payment payment) {
//     if (payment.package != null) {
//       Get.toNamed(
//         '/payment/methods',
//         arguments: {
//           'subjectId': payment.package!.id,
//           'amount': payment.amount,
//           'subjectTitle': payment.package!.name,
//         },
//       );
//     }
//   }
// }
