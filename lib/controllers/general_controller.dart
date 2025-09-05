import 'package:get/get.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/services.dart';

class GeneralController extends GetxController {
  bool _isGradeLoading = false;
  bool get isGradeLoading => _isGradeLoading;

  List<Grade> _grades = [];
  List<Grade> get grades => _grades;

  Future<void> loadGrades() async {
    _isGradeLoading = true;
    update();

    try {
      _grades = await GradeService().getGrades();
      _grades.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load grades');
    } finally {
      _isGradeLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadGrades();
  }
}
