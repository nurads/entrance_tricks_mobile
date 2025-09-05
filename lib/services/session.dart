import 'package:entrance_tricks/models/session.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:entrance_tricks/utils/storages/base.dart';

Session? session;
const String sessionStorage = 'session';

void initializeSession() {
  session = BaseStorage().read(sessionStorage);
}
