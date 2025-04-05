// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:snapride/auth/pages/login_or_signup_page.dart';
import 'package:snapride/providers/auth_provider.dart';
import 'package:snapride/routes/app_routes.dart';
import 'package:snapride/screens/main-screens/screen_controller.dart';
import 'package:snapride/utils/helpers/app_helpers.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // To keep track of the time a user can request for a verification link
  Timer? timer;

  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      // Send verification email and start the timer for periodic checking if the email is not verified.
      provider.sendVerificationEmail(context: context);
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  // A method to check whether a user's email has been verified or not
  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, value, child) => isEmailVerified
          ? const MainHomeScreen() // Navigate to the main home screen if the user has been verified
          : Scaffold(
              // Else, show the verify email page
              backgroundColor: AppColors.kBackgroundColor,
              appBar: AppBar(
                toolbarHeight: 0,
                elevation: 0,
                forceMaterialTransparency: true,
              ),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 50.h,
                        // ),
                        ZoomIn(
                          child: Image.asset(
                            'assets/mail-sent.png',
                            height: 250,
                            width: 250,
                            fit: BoxFit.contain,
                            colorBlendMode: BlendMode.srcIn,
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                        // SizedBox(
                        //   height: 20.h,
                        // ),
                        Text(
                          'Welcome Onboard!',
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
                            'Thank you for signing up! Please verify your email by clicking the link we sent. If you don\'t see it, check your spam folder.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.kGreyColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        AppHelpers.customButton(
                          borderColor: AppColors.kTransparentColor,
                          backgroundColor: AppColors.kPrimaryColor,
                          onPressed: !value.canResendEmail
                              ? null
                              : () {
                                  value.sendVerificationEmail(context: context);
                                },
                          child: !value.canResendEmail
                              ? Center(
                                  child: SpinKitThreeInOut(
                                    size: 18,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                )
                              : Text(
                                  'Resend Link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.kWhiteColor,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                // thickness: 0.2,
                                color: AppColors.kGreyColor.withOpacity(0.26),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.kGreyColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Divider(
                                // thickness: 0.2,
                                color: AppColors.kGreyColor.withOpacity(0.26),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        // If no link received yet after clicking 'resend link' button, try another email
                        GestureDetector(
                          onTap: () {
                            AppRoutes.navigatorPushAndRemoveToTheRight(
                              context: context,
                              child: LoginOrSignupPage(),
                            );
                          },
                          child: Text(
                            'Try another email address',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
