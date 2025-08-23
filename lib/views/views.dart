export 'on_boarding/login.dart';
export 'on_boarding/register.dart';
export 'on_boarding/forgot_password.dart';
export 'on_boarding/verify_phone.dart';

enum VIEWS {
  home('/home'),
  login('/login'),
  register('/register'),
  forgotPassword('/forgotPassword'),
  verifyEmail('/verifyEmail'),
  resetPassword('/resetPassword');

  final String path;

  const VIEWS(this.path);
}
