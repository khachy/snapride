import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:snapride/providers/basic_provider.dart';
import 'package:snapride/routes/app_routes.dart';
import 'package:snapride/screens/starters/onboarding_screen.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // To hold the timer property
  Timer? timer;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BasicProvider>(context, listen: false);
    // check whether a user has allowed permission access
    provider.checkLocationPermissionStatus();
    // Initialize the timer to count for five seconds before navigating to the onboarding screen
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        // navigate to the onboarding screen if the user clicks 'allow'
        if (provider.hasLocationPermission) {
          AppRoutes.navigatorPushReplacement(
            context: context,
            child: const OnboardingScreen(),
          );
        } else {
          // continue showing the permission modal if the user rejects
          await provider.requestLocationPermission();
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BasicProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.kPrimaryColor,
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            forceMaterialTransparency: true,
          ),
          body: Center(
            child: Text(
              'SnapRide',
              style: TextStyle(
                fontSize: 50,
                color: AppColors.kWhiteColor,
                // fontFamily: 'Oxygen',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }
}
