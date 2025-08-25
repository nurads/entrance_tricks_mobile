import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/controllers/on_boarding/login_controller.dart';
import 'package:entrance_tricks/components/components.dart';

class Login extends StatelessWidget {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<LoginController>(
          builder: (controller) => Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Image.asset('assets/images/logo.png'),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Login to continue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: PhoneTextField(controller: controller.phoneController),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PrimaryButton(
                    text: 'Send OTP',
                    onPressed: () => controller.login(),
                    isLoading: controller.isLoading,
                    icon: Icon(Icons.send_outlined),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(VIEWS.register.path);
                      },
                      child: Text(
                        'Register',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
