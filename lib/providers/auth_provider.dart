// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapride/routes/app_routes.dart';
import 'package:snapride/utils/helpers/app_helpers.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // To keep track of the verification status of the user email
  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  bool _canResendEmail = false;
  bool get canResendEmail => _canResendEmail;

  // A method to add user to firestore
  Future<void> addUserDetailsToFirestore({
    required String name,
    required String email,
    required String phone,
  }) async {
    // A user that already have an account
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('riders').doc(user?.uid).set(
      {
        'Full Name': name.trim(),
        'Email Address': email.trim(),
        'Phone Number': phone.trim(),
      },
    );
    log('User Details: {"Full Name": $name, "Email Address": $email, "Phone Number" : $phone}');
    notifyListeners();
  }

  // A method to register new users to firebase database
  Future<void> registerUser({
    required bool isValid,
    required String email,
    required String password,
    required String name,
    required String phone,
    required BuildContext context,
  }) async {
    // show a dialog to prevent users from interacting while loading
    showDialog(
      barrierColor: AppColors.kTransparentColor,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const SizedBox();
      },
    );
    if (isValid) {
      try {
        _isLoading = true;
        notifyListeners();
        // create an account for a new user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        // add the new user to firestore
        addUserDetailsToFirestore(
          name: name.trim(),
          email: email.trim(),
          phone: phone.trim(),
        );
        await Future.delayed(const Duration(seconds: 5));
        // pop the dialog
        Navigator.of(context, rootNavigator: true).pop(true);
      } on FirebaseAuthException catch (e) {
        // pop the dialog
        Navigator.of(context, rootNavigator: true).pop(true);
        AppHelpers.showSnackBar(
          text: e.message!,
          context: context,
          width: 395.w,
          backgroundColor: AppColors.kRedColor,
        );
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      // pop the dialog
      Navigator.of(context, rootNavigator: true).pop(true);
      return;
    }
  }

  // A method used to login existing users to the app
  Future<void> signInUser({
    required bool isValid,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // show a dialog to prevent users from interacting while loading
    showDialog(
      barrierColor: AppColors.kTransparentColor,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const SizedBox();
      },
    );
    if (isValid) {
      try {
        _isLoading = true;
        notifyListeners();
        // create an account for a new user
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        await Future.delayed(const Duration(seconds: 5));
        // pop the dialog
        Navigator.of(context, rootNavigator: true).pop(true);
      } on FirebaseAuthException catch (e) {
        // pop the dialog
        Navigator.of(context, rootNavigator: true).pop(true);
        AppHelpers.showSnackBar(
          text: e.message!,
          context: context,
          width: 395.w,
          backgroundColor: AppColors.kRedColor,
        );
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      // pop the dialog
      Navigator.of(context, rootNavigator: true).pop(true);
      return;
    }
  }

  // A method to allow users request for a password reset link
  Future<void> requestPasswordResetLink({
    required bool isValid,
    required String email,
    required TextEditingController password,
    required BuildContext context,
  }) async {
    // show a dialog to prevent users from interacting while loading
    showDialog(
      barrierColor: AppColors.kTransparentColor,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const SizedBox();
      },
    );
    if (isValid) {
      try {
        _isLoading = true;
        notifyListeners();
        // create an account for a new user
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email.trim(),
        );

        await Future.delayed(const Duration(seconds: 5));
        // pop the dialog
        Navigator.of(context, rootNavigator: true).pop(true);
        // Go back to the login page
        AppRoutes.navigatorPop(context: context);
        // Clear the password in the textfield
        password.clear();
        // show success message
        AppHelpers.showSnackBar(
          text: 'Password reset link sent! check your mail',
          context: context,
          width: 395.w,
          backgroundColor: AppColors.kGreenColor,
        );
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        // pop the dialog
        Navigator.of(context, rootNavigator: true).pop(true);
        AppHelpers.showSnackBar(
          text: e.message!,
          context: context,
          width: 395.w,
          backgroundColor: AppColors.kRedColor,
        );
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      // pop the dialog
      Navigator.of(context, rootNavigator: true).pop(true);
      return;
    }
  }

  // A method used to send verification link to user's email
  Future<void> sendVerificationEmail({required BuildContext context}) async {
    try {
      _canResendEmail = false;
      // notifyListeners();
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      // notifyListeners();
      AppHelpers.showSnackBar(
        text: 'Verification link sent! Please check your mail',
        context: context,
        width: 390.w,
        backgroundColor: AppColors.kGreenColor,
      );
      await Future.delayed(const Duration(seconds: 5));
      _canResendEmail = true;
      notifyListeners();
    } catch (e) {
      AppHelpers.showSnackBar(
        text: e.toString(),
        context: context,
        width: 390.w,
        backgroundColor: AppColors.kRedColor,
      );
    }
  }
}
