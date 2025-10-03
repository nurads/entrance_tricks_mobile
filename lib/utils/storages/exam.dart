import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'base.dart';

class HiveExamStorage extends BaseObjectStorage<List<Exam>> {
  final String _boxName = 'examStorage';
  static late Box<List<dynamic>> _box;
  @override
  Future<void> init() async {
    Hive.registerAdapter<Exam>(ExamTypeAdapter());
    Hive.registerAdapter<Question>(QuestionTypeAdapter());
    Hive.registerAdapter<Choice>(ChoiceTypeAdapter());
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

  Future<List<Exam>> getExams() async {
    final value = _box.get('exams') ?? [];
    for (var exam in value) {
      exam.questions = await getQuestions(exam.id);
      if (exam.questions.isNotEmpty) {
        exam.isDownloaded = true;
      }
    }

    return value.cast<Exam>();
  }

  Future<void> setExams(List<Exam> exams) {
    return _box.put('exams', exams);
  }

  Future<void> setQuizzes(int chapterId, List<Exam> quizzes) {
    logger.i('Setting quizzes for chapter $chapterId');
    return _box.put('quizzes_$chapterId', quizzes);
  }

  Future<List<Exam>> getQuizzes(int chapterId) async {
    final value = _box.get('quizzes_$chapterId') ?? [];
    for (var quiz in value) {
      quiz.questions = await getQuestions(quiz.id);
      if (quiz.questions.isNotEmpty) {
        quiz.isDownloaded = true;
      }
    }
    return value.cast<Exam>();
  }

  Future<List<Question>> getQuestions(int examId) async {
    final value = _box.get('questions_$examId') ?? [];
    for (var question in value) {
      question.imagePath = await getQuestionImages(question.id);
    }
    return value.cast<Question>();
  }

  Future<void> setQuestions(int examId, List<Question> questions) {
    return _box.put('questions_$examId', questions);
  }

  Future<String?> getQuestionImages(int questionId) async {
    final value = _box.get('question_images_$questionId') ?? [];
    return value.cast<String>().firstOrNull;
  }

  Future<void> setQuestionImages(int questionId, String image) {
    return _box.put('question_images_$questionId', [image]);
  }

  Future<void> removeDownloadedExam(int id) async {
    final exams = _box.get('downloaded_exams') ?? [];
    exams.removeWhere((element) => element['id'] == id);
    _box.put('downloaded_exams', exams);
  }

  Future<void> removeAllDownloadedExams() async {
    _box.put('downloaded_exams', []);
  }
}
