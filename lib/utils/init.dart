import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/storages/auth.dart';
import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:entrance_tricks/models/session.dart';
import 'package:entrance_tricks/services/session.dart';

Future<void> initialize() async {
  // Hive Box Initilizer
  await Hive.initFlutter();
  // Hive.registerAdapter<AuthToken>(AuthTokenTypeAdapter());
  Hive.registerAdapter<Session>(SessionTypeAdapter());
  Hive.registerAdapter<User>(UserTypeAdapter());
  Hive.registerAdapter<Grade>(GradeTypeAdapter());
  Hive.registerAdapter<Subject>(SubjectTypeAdapter());
  Hive.registerAdapter<Chapter>(ChapterTypeAdapter());
  // await Hive.deleteBoxFromDisk('baseStorage');
  await Hive.openBox<AuthToken>(authTokenStorage);
  await Hive.openBox<dynamic>('baseStorage');
  await Hive.openBox<Session>(sessionStorage);

  // Network Initilizer

  sessionController.listenSession((session) {
    session = session;
  });

  session = sessionController.getSession();

  // logger.i(session);

  // await ApiClient().initilize();
  logger.i('Initilizing The application');
}
