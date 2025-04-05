import 'package:flutter/material.dart';
import 'package:snapride/screens/main-screens/homePage/home_screen.dart';
// import 'package:iconsax/iconsax.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  // Track the index of the destination
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 55,
        elevation: 6,
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
            print(currentIndex);
          });
        },
        backgroundColor: AppColors.kBackgroundColor,
        indicatorColor: AppColors.kTransparentColor,
        shadowColor: AppColors.kTransparentColor,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_rounded,
              size: 18,
              color: AppColors.kGreyColor,
            ),
            label: 'Home',
            selectedIcon: Icon(
              Icons.home_rounded,
              size: 18,
              color: AppColors.kPrimaryColor,
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.drive_eta_rounded,
              size: 18,
              color: AppColors.kGreyColor,
            ),
            label: 'Rides',
            selectedIcon: Icon(
              Icons.drive_eta_rounded,
              size: 18,
              color: AppColors.kPrimaryColor,
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.account_circle_rounded,
              size: 18,
              color: AppColors.kGreyColor,
            ),
            label: 'Account',
            selectedIcon: Icon(
              Icons.account_circle_rounded,
              size: 18,
              color: AppColors.kPrimaryColor,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          const HomeScreen(),
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
