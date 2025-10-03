import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveExamCompletionStorage extends BaseObjectStorage<bool> {
  final String _boxName = 'examCompletionStorage';
  static late Box<bool> _box;

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<bool>(_boxName);
    } else {
      _box = Hive.box<bool>(_boxName);
    }
  }

  @override
  Future<void> clear() {
    return _box.clear();
  }

  @override
  void listen(void Function(bool) callback, String key) {
    _box.watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<bool?> read(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> write(String key, bool value) {
    return _box.put(key, value);
  }

  String _keyForExam(int examId) => 'completed_$examId';

  Future<void> markCompleted(int examId) async {
    await _box.put(_keyForExam(examId), true);
  }

  Future<void> clearCompleted(int examId) async {
    await _box.delete(_keyForExam(examId));
  }

  Future<bool> isCompleted(int examId) async {
    return _box.get(_keyForExam(examId)) ?? false;
  }

  Future<Set<int>> completedExamIds() async {
    return _box.keys
        .whereType<String>()
        .where((k) => k.startsWith('completed_'))
        .map((k) => int.tryParse(k.split('_').last) ?? 0)
        .where((id) => id != 0)
        .toSet();
  }
}


