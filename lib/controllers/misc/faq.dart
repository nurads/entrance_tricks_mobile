import 'package:get/get.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';

class FAQController extends GetxController {
  final FAQApiService _faqApiService = FAQApiService();

  bool isLoading = false;
  List<FAQ> faqs = [];

  loadFaq() async {
    try {
      isLoading = true;
      update();
      faqs = await _faqApiService.getFAQs();
      faqs.sort((a, b) => a.question.compareTo(b.question));
      faqs = faqs;
    } catch (e) {
      logger.e(e);
      Get.snackbar('Error', 'Failed to load FAQs');
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    loadFaq();
    super.onInit();
  }
}
