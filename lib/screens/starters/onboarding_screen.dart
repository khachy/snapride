import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:snapride/auth/auth_acess/auth_page.dart';
import 'package:snapride/providers/basic_provider.dart';
import 'package:snapride/utils/helpers/app_helpers.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Onboarding data
  final onboardingData = [
    {
      'image': 'assets/onboarding-one.png',
      'text': 'Welcome to SnapRide! - Book rides in seconds and get moving.'
    },
    {
      'image': 'assets/onboarding-two.png',
      'text': 'Set your pickup and destination points with a few taps.'
    },
    {
      'image': 'assets/onboarding-three.png',
      'text':
          'Track your ride in real time - Know exactly when your driver arrives.'
    },
    {
      'image': 'assets/onboarding-four.png',
      'text':
          'Your safety is our priority - Enjoy secure rides and transparent fares.'
    }
  ];

  // To track the index of the page view
  int currentIndex = 0;

  // Page view controller
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    // Initialize the provider to indicate the status of the user
    final provider = Provider.of<BasicProvider>(context, listen: false);
    provider.loadUserOnboardingFlow();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BasicProvider>(
      builder: (context, value, child) => value.userStatus
          ? const AuthPage() // return the auth page if a user has seen the onboarding screens before
          : Scaffold(
              // else return the onboarding screens
              backgroundColor: AppColors.kBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                forceMaterialTransparency: true,
                title: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      // Save the user's status as 'true' after clicking the 'skip' button
                      await value.saveUserOnboardingFlow(
                        status: true,
                        context: context,
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.kGreyColor.withOpacity(0.75),
                      ),
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 350.h,
                        child: PageView.builder(
                          controller: _controller,
                          onPageChanged: (value) {
                            setState(() {
                              currentIndex = value;
                            });
                          },
                          itemCount: onboardingData.length,
                          itemBuilder: (context, index) {
                            final onboardingDataSet = onboardingData[index];
                            return AppHelpers.onboardingContents(
                              image: onboardingDataSet['image']!,
                              text: onboardingDataSet['text']!,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 12,
                                width: index == currentIndex ? 20 : 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: index == currentIndex
                                      ? AppColors.kPrimaryColor
                                      : AppColors.kPrimaryColor
                                          .withOpacity(0.18),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      AppHelpers.customButton(
                        borderColor: AppColors.kTransparentColor,
                        onPressed: () async {
                          if (currentIndex == onboardingData.length - 1) {
                            // Save the user's status as 'true' after completing onboarding
                            await value.saveUserOnboardingFlow(
                              status: true,
                              context: context,
                            );
                          } else {
                            _controller.nextPage(
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(milliseconds: 300),
                            );
                          }
                        },
                        backgroundColor: AppColors.kPrimaryColor,
                        child: Text(
                          currentIndex == onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.kWhiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
