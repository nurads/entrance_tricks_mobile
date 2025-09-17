import 'package:entrance_tricks/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'base.dart';

class HiveQuestionStorage extends BaseObjectStorage<List<Question>> {
  final String _boxName = 'questionStorage';
  @override
  Future<void> init() async {
    Hive.registerAdapter<Question>(QuestionTypeAdapter());
    await Hive.openBox<List<Question>>(_boxName);
  }

  @override
  Future<void> clear() {
    return Hive.box<List<Question>>(_boxName).clear();
  }

  @override
  void listen(void Function(List<Question>) callback, String key) {
    Hive.box<List<Question>>(
      _boxName,
    ).watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<List<Question>?> read(String key) async {
    return Hive.box<List<Question>>(_boxName).get(key) ?? [];
  }

  @override
  Future<void> write(String key, List<Question> value) {
    return Hive.box<List<Question>>(_boxName).put(key, value);
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
}

class HiveNoteStorage extends BaseObjectStorage<List<Note>> {
  final String _boxName = 'noteStorage';
  static late Box<List<dynamic>> _box;
  @override
  Future<void> init() async {
    Hive.registerAdapter<Note>(NoteTypeAdapter());
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<List<dynamic>>(_boxName);
    } else {
      _box = Hive.box<List<dynamic>>(_boxName);
    }
  }

  @override
  Future<void> clear() {
    return Hive.box<List<Note>>(_boxName).clear();
  }

  @override
  void listen(void Function(List<Note>) callback, String key) {
    Hive.box<List<Note>>(
      _boxName,
    ).watch(key: key).listen((event) => callback(event.value));
  }

  @override
  Future<List<Note>?> read(String key) async {
    return Hive.box<List<Note>>(_boxName).get(key) ?? [];
  }

  @override
  Future<void> write(String key, List<Note> value) {
    return Hive.box<List<Note>>(_boxName).put(key, value);
  }

  Future<void> setNotes(int chapterId, List<Note> notes) {
    return _box.put('notes_$chapterId', notes);
  }

  Future<List<Note>> getNotes(int chapterId) async {
    final value = _box.get('notes_$chapterId') ?? [];

    return value.cast<Note>();
  }
}
