import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:snapride/auth/pages/forgot_password_page.dart';
import 'package:snapride/providers/auth_provider.dart';
import 'package:snapride/providers/basic_provider.dart';
import 'package:snapride/routes/app_routes.dart';
import 'package:snapride/utils/helpers/app_helpers.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback togglePages;
  const LoginPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        title: Text(
          'Welcome Back to SnapRide!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Consumer<BasicProvider>(
          builder: (context, value, child) => Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Consumer<AuthenticationProvider>(
                builder: (context, auth, child) => Column(
                  children: [
                    Text(
                      'Log in to continue enjoying seamless ride booking.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.kGreyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    // customTextFields
                    // 1. Email textfield
                    AppHelpers.customTextField(
                      option: 'Enter your registered email address',
                      hintText: 'e.g., johndoe@gmail.com',
                      obscureText: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        RegExp regex = RegExp(
                            r'^(?=.*?[a-z])(?=.*?[@])(?=.*?[a-z])(?=.*?[.])');
                        if (email != null &&
                            !regex.hasMatch(emailController.text)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // 2. password textfield
                    AppHelpers.customTextField(
                      option: 'Enter your password',
                      hintText: '',
                      obscureText: !value.isPasswordVisible ? true : false,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      icon: !value.isPasswordVisible
                          ? Iconsax.eye
                          : Iconsax.eye_slash,
                      onTap: value.passwordVisibility,
                      validator: (password) {
                        RegExp regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~.]).{8,}$');
                        if (password != null && !regex.hasMatch(password)) {
                          return 'Password must contain at least: \n One uppercase letter \n One lowercase letter \n A digit \n One special symbol \n 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          AppRoutes.navigatorPushToTheLeft(
                            context: context,
                            child: ForgotPasswordPage(
                              password: passwordController,
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kRedColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    // custom button
                    AppHelpers.customButton(
                      borderColor: AppColors.kTransparentColor,
                      backgroundColor: AppColors.kPrimaryColor,
                      onPressed: auth.isLoading
                          ? null
                          : () {
                              final isValid = formKey.currentState!.validate();
                              // register a new user
                              auth.signInUser(
                                context: context,
                                isValid: isValid,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            },
                      child: auth.isLoading
                          ? Center(
                              child: SpinKitThreeInOut(
                                size: 18,
                                color: AppColors.kPrimaryColor,
                              ),
                            )
                          : Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kWhiteColor,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.kGreyColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        GestureDetector(
                          onTap: () {
                            value.togglePages();
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }
}
