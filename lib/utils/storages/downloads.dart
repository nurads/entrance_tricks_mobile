import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DownloadedItems extends BaseObjectStorage<List<int>> {
  final _boxName = '';
  Box<List<int>>? _box;
  @override
  Future<void> clear() {
    return Hive.box<List<int>>(_boxName).clear();
  }

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<List<int>>(_boxName);
    } else {
      _box = Hive.box<List<int>>(_boxName);
    }
  }

  @override
  void listen(void Function(List<int> p1) callback, String key) {
    _box?.listenable(keys: [key]).addListener(() {
      callback(_box?.get(key) ?? []);
    });
  }

  @override
  Future<List<int>?> read(String key) async {
    return _box?.get(key);
  }

  @override
  Future<void> write(String key, List<int> value) async {
    return _box?.put(key, value);
  }

  Future<List<int>> getDownloadedExam() async {
    return _box?.get('downloaded_exams') ?? [];
  }

  Future<void> addToDownloadedExams(int examId) async {
    await _box?.put('downloaded_exams', [
      ..._box?.get('downloaded_exams') ?? [],
      examId,
    ]);
  }

  bool isInDownloadedExam(int examId) {
    return _box?.get('downloaded_exams')?.contains(examId) ?? false;
  }
}
