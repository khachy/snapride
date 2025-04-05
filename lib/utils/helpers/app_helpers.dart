import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapride/utils/themes/app_colors.dart';

class AppHelpers {
  static Widget onboardingContents(
      {required String image, required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            child: Image.asset(
              image,
              height: 250,
              width: 250,
              fit: BoxFit.contain,
              colorBlendMode: BlendMode.srcIn,
              color: AppColors.kPrimaryColor,
            ),
          ),
          // SizedBox(
          //   height: 8.h,
          // ),
          SlideInUp(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  static Widget customButton({
    required Color borderColor,
    required Color backgroundColor,
    required void Function()? onPressed,
    required Widget child,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: backgroundColor,
        ),
        child: Center(child: child),
      ),
    );
  }

  static Widget customTextField({
    required String option,
    IconData? icon,
    required String hintText,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    required bool obscureText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool? isVisible,
    int? maxLength,
    List<TextInputFormatter>? inputFormatter,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title of the textfield
        Visibility(
          visible: isVisible ?? true,
          child: Text(
            option,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.kGreyColor.withOpacity(0.7),
            ),
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
        TextFormField(
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.words,
          maxLength: maxLength,
          controller: controller,
          style: const TextStyle(
            fontSize: 16,
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatter,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.kPrimaryColor.withOpacity(0.06),
            contentPadding: EdgeInsets.symmetric(
              vertical: 6.h,
              horizontal: 15.w,
            ),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.kPrimaryColor.withOpacity(0.18),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.kPrimaryColor.withOpacity(0.18),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.kRedColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.kRedColor,
              ),
            ),
            errorStyle: const TextStyle(
              color: AppColors.kRedColor,
            ),
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: Icon(
                icon,
                color: AppColors.kGreyColor,
                size: 20,
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.kGreyColor.withOpacity(0.6),
            ),
          ),
          validator: validator,
        )
      ],
    );
  }

  static ScaffoldMessengerState showSnackBar({
    required String text,
    required BuildContext context,
    required double width,
    required Color backgroundColor,
  }) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.kWhiteColor,
        ),
        textAlign: TextAlign.center,
      ),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: backgroundColor,
    );
    return ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Widget bottomSheetIndicator() {
    return Container(
      height: 6,
      width: 64,
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  static Widget containerInSheet({required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8)),
              child: child),
        ),
      ),
    );
  }
}
