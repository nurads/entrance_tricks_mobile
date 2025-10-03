import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveExamProgressStorage extends BaseObjectStorage<Map<String, dynamic>> {
  final String _boxName = 'examProgressStorage';
  static late Box<Map<String, dynamic>> _box;

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Map<String, dynamic>>(_boxName);
    } else {
      _box = Hive.box<Map<String, dynamic>>(_boxName);
    }
  }

  @override
  Future<void> clear() {
    return _box.clear();
  }

  @override
  void listen(void Function(Map<String, dynamic>) callback, String key) {
    _box.watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<Map<String, dynamic>?> read(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> write(String key, Map<String, dynamic> value) {
    return _box.put(key, value);
  }

  String _keyForExam(int examId, String mode) => 'progress_${examId}_$mode';

  Future<Map<String, dynamic>?> getProgress(int examId, String mode) async {
    return _box.get(_keyForExam(examId, mode));
  }

  Future<void> saveProgress(
    int examId, {
    required int currentIndex,
    required List<int?> answers,
    required int timeRemaining,
    required String mode,
  }) async {
    await _box.put(_keyForExam(examId, mode), {
      'current_question_index': currentIndex,
      'selected_answers': answers,
      'remaining_time': timeRemaining,
      'mode': mode,
    });
  }

  Future<void> clearProgress(int examId, String mode) async {
    await _box.delete(_keyForExam(examId, mode));
  }
}


