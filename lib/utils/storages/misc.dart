import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveSubjectsStorage extends BaseObjectStorage<List<Subject>> {
  final String _boxName = 'subjectsStorage';
  static late Box<List<dynamic>> _box;

  @override
  Future<void> init() async {
    Hive.registerAdapter<Subject>(SubjectTypeAdapter());

    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<List<dynamic>>(_boxName);
    } else {
      _box = Hive.box<List<dynamic>>(_boxName);
    }
  }

  @override
  Future<int?> clear() async {
    return _box.clear();
  }

  @override
  void listen(void Function(List<Subject>) callback, String key) {
    Hive.box<List<Subject>>(
      _boxName,
    ).watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<List<Subject>> read(String key) async {
    // logger.i(Hive.box<List<dynamic>>(_boxName).get(key));
    final value = _box.get(key) ?? [];
    return value.cast<Subject>();
  }

  @override
  Future<void> write(String key, List<Subject> value) async {
    logger.i('Inserting subjects to storage');
    logger.i(_box);
    return _box.put(key, value);
  }
}

// class HiveGradesStorage extends BaseObjectStorage<List<Grade>> {
//   final String _boxName = 'gradesStorage';

//   @override
//   Future<void> init() async {
//     Hive.registerAdapter<Grade>(GradeTypeAdapter());
//     await Hive.openBox<List<Grade>>(_boxName);
//   }

//   @override
//   Future<void> clear() {
//     return Hive.box<List<Grade>>(_boxName).clear();
//   }

//   @override
//   void listen(void Function(List<Grade> p1) callback, String key) {
//     Hive.box<List<Grade>>(
//       _boxName,
//     ).watch(key: key).listen((event) => callback(event.value));
//   }

//   @override
//   Future<List<Grade>?> read(String key) async {
//     return Hive.box<List<Grade>>(_boxName).get(key);
//   }

//   @override
//   Future<void> write(String key, List<Grade> value) {
//     return Hive.box<List<Grade>>(_boxName).put(key, value);
//   }
// }

class HiveVideoStorage extends BaseObjectStorage<List<Video>> {
  final String _boxName = 'videoStorage';

  @override
  Future<void> init() async {
    Hive.registerAdapter<Video>(VideoTypeAdapter());
    await Hive.openBox<List<Video>>(_boxName);
  }

  @override
  Future<void> clear() {
    return Hive.box<List<Video>>(_boxName).clear();
  }

  @override
  void listen(void Function(List<Video> p1) callback, String key) {
    Hive.box<List<Video>>(
      _boxName,
    ).watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<List<Video>?> read(String key) async {
    return Hive.box<List<Video>>(_boxName).get(key);
  }

  @override
  Future<void> write(String key, List<Video> value) {
    return Hive.box<List<Video>>(_boxName).put(key, value);
  }
}

class HiveChaptersStorage extends BaseObjectStorage<List<Chapter>> {
  final String _boxName = 'chaptersStorage';

  static late Box<List<dynamic>> _box;

  @override
  Future<void> init() async {
    Hive.registerAdapter<Chapter>(ChapterTypeAdapter());

    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<List<dynamic>>(_boxName);
    } else {
      _box = Hive.box<List<dynamic>>(_boxName);
    }
  }

  @override
  Future<void> clear() {
    return _box.clear();
  }

  @override
  void listen(void Function(List<Chapter> p1) callback, String key) {
    _box.watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<List<Chapter>> read(String key) async {
    final value = _box.get(key) ?? [];
    return value.cast<Chapter>();
  }

  @override
  Future<void> write(String key, List<Chapter> value) {
    return _box.put(key, value);
  }

  Future<void> setChapters(int subjectId, List<Chapter> chapters) {
    return _box.put('chapters_$subjectId', chapters);
  }
}
