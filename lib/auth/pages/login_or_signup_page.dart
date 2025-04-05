import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapride/auth/pages/login_page.dart';
import 'package:snapride/auth/pages/signup_page.dart';
import 'package:snapride/providers/basic_provider.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BasicProvider>(
      builder: (context, value, child) => Scaffold(
        body: value.isLoginPage
            ? LoginPage(
                togglePages: value.togglePages,
              )
            : SignupPage(
                togglePages: value.togglePages,
              ),
      ),
    );
  }
}
