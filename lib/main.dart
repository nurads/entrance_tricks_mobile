import 'package:flutter/material.dart';
import 'package:entrance_tricks/views/home/home.dart';
import 'package:entrance_tricks/views/payment_history_screen.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/components/components.dart';
import 'package:entrance_tricks/utils/utils.dart';

void main() async {
  // Remove debug banner
  await initialize();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final service = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Entrance Tricks',
      theme: lightTheme(context),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const Home(),
      getPages: [
        GetPage(name: VIEWS.home.path, page: () => const Home()),
        GetPage(name: VIEWS.login.path, page: () => Login()),
        GetPage(name: VIEWS.register.path, page: () => Register()),
        GetPage(name: VIEWS.verifyPhone.path, page: () => VerifyPhone()),
        GetPage(name: VIEWS.subjectDetail.path, page: () => SubjectDetail()),
        GetPage(name: VIEWS.chapterDetail.path, page: () => ChapterDetail()),
        GetPage(name: VIEWS.editProfile.path, page: () => EditProfilePage()),
        GetPage(name: VIEWS.subjects.path, page: () => SubjectPage()),
        // Move paymentHistory route before payment route to fix route matching
        GetPage(
          name: VIEWS.paymentHistory.path,
          page: () => PaymentHistoryScreen(),
        ),
        GetPage(name: VIEWS.payment.path, page: () => PaymentPage()),
        GetPage(name: VIEWS.examDetail.path, page: () => ExamDetailPage()),
        GetPage(name: VIEWS.downloads.path, page: () => DownloadsPage()),
        GetPage(name: VIEWS.support.path, page: () => SupportPage()),
        GetPage(name: VIEWS.about.path, page: () => AboutPage()),
        GetPage(name: VIEWS.faq.path, page: () => FAQPage()),
        // GetPage(name: VIEWS.notes.path, page: () => NotesPage()),
        // GetPage(name: VIEWS.videos.path, page: () => VideosPage()),
        // GetPage(name: VIEWS.paymentHistory.path, page: () => PaymentHistoryPage()),
        // GetPage(name: VIEWS.paymentMethods.path, page: () => PaymentMethodsPage()),
        // GetPage(name: VIEWS.receiptUpload.path, page: () => ReceiptUploadPage()),
        // GetPage(
        //   name: VIEWS.forgotPassword.name,
        //   page: () => const ForgotPassword(),
        // ),
        // GetPage(name: VIEWS.verifyEmail.name, page: () => const VerifyEmail()),
        // GetPage(
        //   name: VIEWS.resetPassword.name,
        //   page: () => const ResetPassword(),
        // ),
      ],
      initialRoute: service.user.value != null
          ? VIEWS.home.path
          : VIEWS.login.path,
    );
  }
}
