export 'auth/login.dart';
export 'auth/register.dart';
export 'auth/forgot_password.dart';
export 'auth/verify_phone.dart';
export 'home/home_dashboard.dart';
export 'subject/subject_detail.dart';
export 'subject/chapter_detail.dart';
export 'exam/exam_page.dart';
export 'news/news_page.dart';
export 'common/profile_page.dart';
export 'subject/subject_page.dart';
export 'common/search_page.dart';
export 'common/notifications_page.dart';
export 'payment/payment_page.dart';
export 'exam/exam_detail_page.dart';
export 'exam/exam_result_page.dart';
export 'news/news_detail_page.dart';
export 'quiz/quiz_detail_page.dart';
export 'quiz/quiz_taking_page.dart';

enum VIEWS {
  home('/home'),
  login('/login'),
  register('/register'),
  forgotPassword('/forgotPassword'),
  verifyPhone('/verifyPhone'),
  verifyEmail('/verifyEmail'),
  resetPassword('/resetPassword'),
  subjectDetail('/subject-detail'),
  chapterDetail('/chapter-detail');

  final String path;

  const VIEWS(this.path);
}
