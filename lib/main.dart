import 'package:flutter/material.dart';
import 'package:entrance_tricks/views/home/home.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/controllers/controllers.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/components/components.dart';
import 'package:entrance_tricks/utils/utils.dart';

void main() async {
  // Remove debug banner
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final service = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    logger.d(service.user.value);
    return GetMaterialApp(
      title: 'Entrance Tricks',
      theme: lightTheme(context),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const Home(),
      getPages: [
        GetPage(
          name: VIEWS.home.path,
          page: () => const Home(),
          bindings: [
            BindingsBuilder(() {
              Get.lazyPut(() => HomeDashboardController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => MainNavigationController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => DownloadsController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => ProfileController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => ExamController());
            }),
          ],
        ),
        GetPage(
          name: VIEWS.login.path,
          page: () => Login(),
          bindings: [
            BindingsBuilder(() {
              Get.lazyPut(() => LoginController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => MainNavigationController());
            }),
          ],
        ),
        GetPage(
          name: VIEWS.register.path,
          page: () => Register(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => RegisterController());
          }),
        ),
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
        GetPage(name: VIEWS.downloads.path, page: () => DownloadsPage()),
        GetPage(name: VIEWS.support.path, page: () => SupportPage()),
        GetPage(name: VIEWS.about.path, page: () => AboutPage()),
        GetPage(name: VIEWS.faq.path, page: () => FAQPage()),
      ],
      initialRoute: service.user.value != null
          ? VIEWS.home.path
          : VIEWS.login.path,
    );
  }
}
