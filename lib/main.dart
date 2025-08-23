import 'package:flutter/material.dart';
import 'package:entrance_tricks/views/home.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/components/components.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Entrance Tricks',
      theme: lightTheme(context),
      home: const Home(),
      getPages: [
        GetPage(name: VIEWS.home.path, page: () => const Home()),
        GetPage(name: VIEWS.login.path, page: () => Login()),
        GetPage(name: VIEWS.register.path, page: () => Register()),
        GetPage(name: VIEWS.verifyPhone.path, page: () => VerifyPhone()),
        GetPage(name: VIEWS.subjectDetail.path, page: () => SubjectDetail()),
        GetPage(name: VIEWS.chapterDetail.path, page: () => ChapterDetail()),
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
      initialRoute: VIEWS.login.path,
    );
  }
}
