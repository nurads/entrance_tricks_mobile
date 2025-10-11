import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';
import 'package:entrance_tricks/utils/storages/storages.dart';

class SubjectDetailController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool isLocked = true;

  String _subjectName = '';
  String get subjectName => _subjectName;

  List<Chapter> _chapters = [];
  List<Chapter> get chapters => _chapters;

  int subjectId = 0;
  // ignore: unused_field
  User? _user;
  late StreamSubscription<InternetStatus> _internetStatusSubscription;

  @override
  void onInit() async {
    super.onInit();
    subjectId = Get.arguments?['subjectId'] ?? 1;
    _user = await HiveUserStorage().getUser();
    loadSubjectDetail();
    _internetStatusSubscription = InternetConnection().onStatusChange.listen((
      event,
    ) {
      if (event == InternetStatus.connected) {
        loadSubjectDetail();
      }
    });
  }

  void loadSubjectDetail() async {
    _isLoading = true;
    update();
    try {
      Subject subject = (await HiveSubjectsStorage().read(
        'subjects',
      )).firstWhere((element) => element.id == subjectId);
      logger.i('subject: $subject ${subject.isLocked}');

      isLocked = subject.isLocked;

      _subjectName = subject.name;
      _chapters = subject.chapters;
      _chapters.sort((e1, e2) => e1.chapterNumber.compareTo(e2.chapterNumber));
    } catch (e) {
      logger.e(e);
      Get.snackbar('Error', 'Failed to load subject details');
      rethrow;
    } finally {
      _isLoading = false;
      update();
    }
  }

  void openChapter(int chapterId) {
    Get.toNamed(
      VIEWS.chapterDetail.path,
      arguments: {'chapterId': chapterId, 'subjectId': subjectId},
    );
  }

  @override
  void onClose() {
    _internetStatusSubscription.cancel();
    super.onClose();
  }
}
