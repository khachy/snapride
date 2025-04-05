import 'package:flutter/material.dart';

class AppRoutes {
  // Navigator.pushReplacement route
  static void navigatorPushReplacement(
      {required BuildContext context, required Widget child}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return child;
        },
      ),
    );
  }

  // Navigator.pushReplacement with animation route
  static void navigatorPushReplacementWithAnimation(
      {required BuildContext context, required Widget child}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).chain(
                CurveTween(curve: Curves.fastLinearToSlowEaseIn),
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  // Navigator.pushAndRemove (right) route
  static void navigatorPushAndRemoveToTheRight(
      {required BuildContext context, required Widget child}) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero).chain(
                CurveTween(curve: Curves.fastLinearToSlowEaseIn),
              ),
            ),
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }

  // Navigator.push (left) route
  static void navigatorPushToTheLeft(
      {required BuildContext context, required Widget child}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).chain(
                CurveTween(curve: Curves.fastLinearToSlowEaseIn),
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  // Naviagtor.pop route
  static void navigatorPop({required BuildContext context}) {
    Navigator.of(context).pop();
  }
}
