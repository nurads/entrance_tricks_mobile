export 'on_boarding/login.dart';
export 'on_boarding/register.dart';
export 'on_boarding/forgot_password.dart';
export 'on_boarding/verify_phone.dart';
export 'home_dashboard.dart';
export 'subject_detail.dart';
export 'chapter_detail.dart';
export 'exam_page.dart';
export 'news_page.dart';
export 'profile_page.dart';
export 'subject_page.dart';
export 'search_page.dart';
export 'notifications_page.dart';
export 'payment_page.dart';
export 'exam_detail_page.dart';
export 'exam_result_page.dart';
export 'news_detail_page.dart';
export 'quiz_detail_page.dart';
export 'quiz_taking_page.dart';
export 'notifications_page.dart';

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
