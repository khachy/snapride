import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:snapride/providers/auth_provider.dart';
import 'package:snapride/utils/helpers/app_helpers.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  final TextEditingController password;
  const ForgotPasswordPage({
    super.key,
    required this.password,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // controllers
  final emailController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 50.h,
                    // ),
                    ZoomIn(
                      child: Image.asset(
                        'assets/reset-password.png',
                        height: 250,
                        width: 250,
                        fit: BoxFit.contain,
                        colorBlendMode: BlendMode.srcIn,
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Reset Your Password!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Text(
                        'Forgot password? Don\'t worry, it happens. To reset your password, please provide the registered email address associated with this account.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.kGreyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                      height: 50.h,
                    ),
                    AppHelpers.customButton(
                      borderColor: AppColors.kTransparentColor,
                      backgroundColor: AppColors.kPrimaryColor,
                      onPressed: value.isLoading
                          ? null
                          : () {
                              value.requestPasswordResetLink(
                                isValid: formKey.currentState!.validate(),
                                email: emailController.text,
                                password: widget.password,
                                context: context,
                              );
                            },
                      child: value.isLoading
                          ? Center(
                              child: SpinKitThreeInOut(
                                size: 18,
                                color: AppColors.kPrimaryColor,
                              ),
                            )
                          : Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kWhiteColor,
                              ),
                            ),
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
