import 'package:flutter/material.dart';
import 'package:vector_academy/views/home/home.dart';
import 'package:vector_academy/views/views.dart';
import 'package:vector_academy/controllers/controllers.dart';
import 'package:get/get.dart';
import 'package:vector_academy/services/services.dart';
import 'package:vector_academy/components/components.dart';
import 'package:vector_academy/utils/utils.dart';

void main() async {
  // Remove debug banner
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  // Initialize deep link service
  DeepLinkService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final service = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vector Academy',
      theme: lightTheme(context),
      debugShowCheckedModeBanner: true, // Remove debug banner
      getPages: [
        GetPage(
          name: VIEWS.home.path,
          page: () => const Home(),
          binding: BindingsBuilder(() {
            Get.put(MainNavigationController(), permanent: true);
            Get.put(HomeDashboardController(), permanent: true);
            Get.put(ProfileController(), permanent: true);
            Get.put(ExamController(), permanent: true);
            Get.put(NewsController(), permanent: true);
            Get.put(DownloadsController(), permanent: true);
            Get.put(StudyPlannerService(), permanent: true);
            Get.put(StudyPlannerController(), permanent: true);
          }),
        ),
        GetPage(
          name: VIEWS.login.path,
          page: () => Login(),
          bindings: [
            BindingsBuilder(() {
              Get.put(LoginController(), permanent: true);
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
        GetPage(name: VIEWS.downloads.path, page: () => DownloadsPage()),
        GetPage(name: VIEWS.support.path, page: () => SupportPage()),
        GetPage(name: VIEWS.about.path, page: () => AboutPage()),
        GetPage(
          name: VIEWS.newsDetail.path,
          page: () {
            return NewsDetailPage();
          },
        ),
        GetPage(
          name: VIEWS.faq.path,
          page: () => FAQPage(),
          binding: BindingsBuilder(() {
            Get.put(FAQController());
          }),
        ),
        GetPage(
          name: '/add-plan',
          page: () => AddPlanPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AddPlanController());
          }),
        ),
      ],
      initialRoute: service.user.value != null
          ? VIEWS.home.path
          : VIEWS.login.path,
    );
  }
}
