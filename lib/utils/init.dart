import 'package:entrance_tricks/services/api/api.dart';
import 'package:entrance_tricks/utils/storages/storages.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/services/auth.dart';
import 'package:entrance_tricks/services/core.dart';
import 'package:entrance_tricks/services/api/grades.dart';
import 'package:flutter_tex/flutter_tex.dart';

Future<void> initialize() async {
  await TeXRenderingServer.start();
  await Hive.initFlutter();
  await HiveChaptersStorage().init();
  await HiveSubjectsStorage().init();
  await HiveAuthStorage().init();
  await HiveUserStorage().init();
  await HiveExamStorage().init();
  await HiveQuizzesStorage().init();
  await HiveNoteStorage().init();
  await HiveVideoStorage().init();
  Get.put(AuthService());
  Get.put(CoreService());
  Get.put(GradeService());

  final authToken = await HiveAuthStorage().getAuthToken();

  BaseApiClient.setTokens(authToken?.access ?? '', authToken?.refresh ?? '');

  logger.i('Initilizing The application');
}
