import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
