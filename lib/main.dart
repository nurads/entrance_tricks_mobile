import 'package:entrance_tricks/services/session.dart';
import 'package:flutter/material.dart';
import 'package:entrance_tricks/views/home/home.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/components/components.dart';
import 'package:entrance_tricks/utils/utils.dart';

void main() async {
  // Remove debug banner
  await initialize();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        GetPage(name: '/payment', page: () => PaymentPage()),
        GetPage(name: '/exam-detail', page: () => ExamDetailPage()),
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
      initialRoute: session != null ? VIEWS.home.path : VIEWS.login.path,
    );
  }
}
