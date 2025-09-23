import 'package:entrance_tricks/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'base.dart';

class HiveQuestionStorage extends BaseObjectStorage<List<Question>> {
  final String _boxName = 'questionStorage';
  static Box<List<dynamic>>? _box;
  @override
  Future<void> init() async {
    Hive.registerAdapter<Question>(QuestionTypeAdapter());
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<List<dynamic>>(_boxName);
    } else {
      _box = Hive.box<List<dynamic>>(_boxName);
    }
  }

  @override
  Future<void> clear() async {
    _box?.clear();
  }

  @override
  void listen(void Function(List<Question>) callback, String key) {
    _box?.watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<List<Question>?> read(String key) async {
    final values = _box?.get(key) ?? [];
    return values.cast<Question>();
  }

  @override
  Future<void> write(String key, List<Question> value) async {
    _box?.put(key, value);
  }

  Future<List<Question>> getQuestions(int examId) async {
    final value = _box?.get('questions_$examId') ?? [];
    return value.cast<Question>();
  }

  Future<void> setQuestions(int examId, List<Question> questions) async {
    _box?.put('questions_$examId', questions);
  }
}

class HiveExamStorage extends BaseObjectStorage<List<Exam>> {
  final String _boxName = 'examStorage';
  static late Box<List<dynamic>> _box;
  @override
  Future<void> init() async {
    Hive.registerAdapter<Exam>(ExamTypeAdapter());
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<List<dynamic>>(_boxName);
    } else {
      _box = Hive.box<List<dynamic>>(_boxName);
    }
  }

  @override
  void listen(void Function(List<Exam>) callback, String key) {
    _box.watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<void> clear() {
    return _box.clear();
  }

  @override
  Future<List<Exam>> read(String key) async {
    final value = _box.get(key) ?? [];
    return value.cast<Exam>();
  }

  @override
  Future<void> write(String key, List<Exam> value) {
    return _box.put(key, value);
  }

  Future<void> setQuizzes(int chapterId, List<Exam> quizzes) {
    return _box.put('quizzes_$chapterId', quizzes);
  }

  Future<List<Exam>> getQuizzes(int chapterId) async {
    final value = _box.get('quizzes_$chapterId') ?? [];
    return value.cast<Exam>();
  }
}
