import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:snapride/providers/auth_provider.dart';
import 'package:snapride/providers/basic_provider.dart';
import 'package:snapride/utils/helpers/app_helpers.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback togglePages;
  const SignupPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();
  String phoneNumber = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        title: Text(
          'Join SnapRide Today!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Consumer<BasicProvider>(
          builder: (context, value, child) => Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Consumer<AuthenticationProvider>(
                builder: (context, auth, child) => Column(
                  children: [
                    Text(
                      'Sign up now to experience fast, secure, and hassle-free rides.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.kGreyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    // customTextFields
                    // 1. Full name textfield
                    AppHelpers.customTextField(
                      option: 'Enter your full name',
                      hintText: 'e.g., John Doe',
                      obscureText: false,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (name) {
                        // RegExp regex = RegExp(
                        //     r'^(?=.*?[a-z])(?=.*?[@])(?=.*?[a-z])(?=.*?[.])');
                        if (name != null && nameController.text.isEmpty) {
                          return 'Enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),

                    // 2. Phone number textfield
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Enter your phone number',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.kGreyColor.withOpacity(0.7),
                          ),
                        ),
                        // SizedBox(
                        //   height: 3.h,
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 48,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.kPrimaryColor.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      AppColors.kPrimaryColor.withOpacity(0.18),
                                ),
                              ),
                              child: CountryCodePicker(
                                elevation: 0,
                                enabled: false,
                                searchDecoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      AppColors.kPrimaryColor.withOpacity(0.06),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.h,
                                    horizontal: 15.w,
                                  ),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.kPrimaryColor
                                          .withOpacity(0.18),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.kPrimaryColor
                                          .withOpacity(0.18),
                                    ),
                                  ),
                                ),
                                mode: CountryCodePickerMode.bottomSheet,
                                onChanged: (country) {
                                  setState(() {
                                    phoneNumber = '';
                                    phoneNumber += country.dialCode;
                                  });
                                  print('Phone number: $phoneNumber');
                                },
                                onInit: (value) {
                                  phoneNumber = '';
                                  phoneNumber += value!.dialCode;

                                  print('Phone number: $phoneNumber');
                                },
                                initialSelection: 'NG',
                                showFlag: true,
                                showDropDownButton: false,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: AppHelpers.customTextField(
                                option: '',
                                isVisible: false,
                                hintText: 'e.g., 01234567890',
                                obscureText: false,
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (phone) {
                                  if (phone != null &&
                                      phoneController.text.length != 10) {
                                    return 'Enter a valid phone number';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // 2. Email textfield
                    AppHelpers.customTextField(
                      option: 'Provide your email address',
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
                      height: 20.h,
                    ),

                    // 3. password textfield
                    AppHelpers.customTextField(
                      option: 'Create a secure password',
                      hintText: '',
                      obscureText: !value.isPasswordVisible ? true : false,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      icon: !value.isPasswordVisible
                          ? Iconsax.eye
                          : Iconsax.eye_slash,
                      onTap: value.passwordVisibility,
                      validator: (password) {
                        RegExp regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~.]).{8,}$');
                        if (password != null && !regex.hasMatch(password)) {
                          return 'Password must contain at least: \n One uppercase letter \n One lowercase letter \n A digit \n One special symbol \n 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // 4. confirm password textfield
                    AppHelpers.customTextField(
                      option: 'Re-enter your password for confirmation',
                      hintText: '',
                      obscureText: !value.isPasswordVisible ? true : false,
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      icon: !value.isPasswordVisible
                          ? Iconsax.eye
                          : Iconsax.eye_slash,
                      onTap: value.passwordVisibility,
                      validator: (password) {
                        if (password != null &&
                            password != passwordController.text) {
                          return 'Password mismatch';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 50.h,
                    ),
                    // custom button
                    AppHelpers.customButton(
                      borderColor: AppColors.kTransparentColor,
                      backgroundColor: AppColors.kPrimaryColor,
                      onPressed: auth.isLoading
                          ? null
                          : () {
                              final isValid = formKey.currentState!.validate();
                              // register a new user
                              auth.registerUser(
                                context: context,
                                isValid: isValid,
                                name: nameController.text,
                                email: emailController.text,
                                password: confirmPasswordController.text,
                                phone: phoneNumber += phoneController.text,
                              );
                            },
                      child: auth.isLoading
                          ? Center(
                              child: SpinKitThreeInOut(
                                size: 18,
                                color: AppColors.kPrimaryColor,
                              ),
                            )
                          : Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kWhiteColor,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.kGreyColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        GestureDetector(
                          onTap: () {
                            value.togglePages();
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
