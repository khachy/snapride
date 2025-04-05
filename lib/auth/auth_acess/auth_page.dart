import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapride/auth/pages/login_or_signup_page.dart';
import 'package:snapride/auth/pages/verify_email_page.dart';
import 'package:snapride/screens/starters/splash_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading indicator while waiting for authentication status.
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Loading...');
          } else {
            if (snapshot.hasData) {
              // The user is signed in, so display the VerifyEmailPage.
              return VerifyEmailPage();
            } else {
              // The user is not signed in.
              return LoginOrSignupPage();
            }
          }
          return const SplashScreen();
        },
      ),
    );
  }
}
