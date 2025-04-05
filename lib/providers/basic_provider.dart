// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapride/auth/auth_acess/auth_page.dart';
import 'package:snapride/routes/app_routes.dart';

class BasicProvider with ChangeNotifier {
  bool _userStatus = false;
  bool get userStatus => _userStatus;

  bool _isLoginPage = true;
  bool get isLoginPage => _isLoginPage;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _hasLocationPermission = false;
  bool get hasLocationPermission => _hasLocationPermission;

  // Save the status of the user that has viewed the onboarding screens
  Future<void> saveUserOnboardingFlow(
      {required bool status, required BuildContext context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasViewedOnboarding', status);
      _userStatus = status; // Update local state immediately
      notifyListeners();
      // Navigate to the 'AuthPage' after clicking the 'Get Started' button
      AppRoutes.navigatorPushReplacementWithAnimation(
        context: context,
        child: const AuthPage(),
      );
      print('Onboarding status saved: $status');
    } catch (error) {
      print('Error saving onboarding status: $error');
    }
  }

  // Load the status of the user to know if they have viewed the onboarding screens before
  Future<void> loadUserOnboardingFlow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userStatus = prefs.getBool('hasViewedOnboarding') ?? false;
      notifyListeners();
    } catch (error) {
      print('Error loading onboarding status: $error');
    }
  }

  // A function to toggle between login and signup page
  void togglePages() {
    _isLoginPage = !_isLoginPage;
    notifyListeners();
  }

  // A function to make password visible or not
  void passwordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // A function to check user for location permission status
  Future<void> checkLocationPermissionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasPermission = prefs.getBool('hasLocationPermission');

    if (hasPermission == true) {
      _hasLocationPermission = true;
      notifyListeners();
    } else {
      // Check current permission status using Geolocator
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await requestLocationPermission();
      } else {
        // Permission already granted
        await _savePermissionStatus(true);

        _hasLocationPermission = true;
        notifyListeners();
      }
    }
  }

  // A function to request user's location permission
  Future<void> requestLocationPermission() async {
    // Request permission using Geolocator
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // Save that the user has granted permission
      await _savePermissionStatus(true);

      _hasLocationPermission = true;
      notifyListeners();
    } else {
      // If permission is denied, update the state to allow retry
      _hasLocationPermission = false;
      notifyListeners();
    }
  }

  Future<void> _savePermissionStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasLocationPermission', status);
    _hasLocationPermission = status;
    print('Location Permission granted: $status');
    notifyListeners();
  }
}
