import 'package:hive_flutter/hive_flutter.dart';
import 'package:entrance_tricks/models/session.dart';
import 'package:entrance_tricks/services/session.dart';

class BaseStorage {
  static final BaseStorage _instance = BaseStorage._init();
  final _box = Hive.box("baseStorage");
  factory BaseStorage() => _instance;

  BaseStorage._init();

  Future<int?> getInt(String key) async {
    return _box.get(key);
  }

  Future<String?> getString(String key) async {
    return _box.get(key);
  }

  Future<void> remove(String key) async {
    _box.delete(key);
  }

  Future<void> setInt(String key, int value) {
    return _box.put(key, value);
  }

  Future<void> setString(String key, String value) async {
    _box.put(key, value);
  }

  read<T>(String key) => _box.get(key) as T;

  write<T>(String key, T value) => _box.put(key, value);

  addListener<T>(void Function(T) callback, String key) async =>
      _box.listenable(keys: [key]).addListener(() => callback(_box.get(key)));
}

class BaseSessionController {
  final BaseStorage baseStorage = BaseStorage();
  void setSession(Session session) {
    baseStorage.write(sessionStorage, session);
  }

  Session? getSession() {
    return baseStorage.read<Session?>(sessionStorage);
  }

  void logout() {
    baseStorage.remove(sessionStorage);
  }

  void login(Session? session) {
    baseStorage.write<Session?>(sessionStorage, session);
  }

  void listenSession(void Function(Session) callback) {
    baseStorage.addListener(callback, sessionStorage);
  }
}

BaseSessionController sessionController = BaseSessionController();
