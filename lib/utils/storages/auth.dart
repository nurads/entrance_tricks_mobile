import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveAuthStorage extends BaseObjectStorage<AuthToken> {
  final String _boxName = 'authTokenStorage';

  @override
  Future<void> init() async {
    Hive.registerAdapter<Grade>(GradeTypeAdapter());
    Hive.registerAdapter<AuthToken>(AuthTokenTypeAdapter());
    await Hive.openBox<AuthToken>(_boxName);
  }

  @override
  void listen(void Function(AuthToken) callback, String key) {
    final box = Hive.box<AuthToken>(_boxName);
    box.watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<void> clear() {
    final box = Hive.box<AuthToken>(_boxName);
    return box.clear();
  }

  @override
  Future<AuthToken?> read(String key) async {
    return Hive.box<AuthToken>(_boxName).get(key);
  }

  @override
  Future<void> write(String key, AuthToken value) {
    return Hive.box<AuthToken>(_boxName).put(key, value);
  }

  Future<AuthToken?> getAuthToken() async {
    return Hive.box<AuthToken>(_boxName).get('authToken');
  }

  Future<void> setAuthToken(AuthToken authToken) {
    return Hive.box<AuthToken>(_boxName).put('authToken', authToken);
  }
}

class HiveUserStorage extends BaseObjectStorage<User> {
  final String _boxName = 'userStorage';

  @override
  Future<void> init() async {
    Hive.registerAdapter<User>(UserTypeAdapter());
    await Hive.openBox<User>(_boxName);
  }

  @override
  Future<void> clear() {
    return Hive.box<User>(_boxName).clear();
  }

  @override
  void listen(void Function(User p1) callback, String key) {
    Hive.box<User>(
      _boxName,
    ).watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<User?> read(String key) async {
    return Hive.box<User>(_boxName).get(key);
  }

  @override
  Future<void> write(String key, User value) {
    return Hive.box<User>(_boxName).put(key, value);
  }

  Future<User?> getUser() async {
    return Hive.box<User>(_boxName).get('user');
  }

  Future<void> setUser(User user) {
    return Hive.box<User>(_boxName).put('user', user);
  }
}
