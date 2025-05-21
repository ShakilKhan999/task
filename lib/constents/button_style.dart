import 'package:flutter/material.dart';
import 'package:flutter_noti/constents/app_colors.dart';
import 'package:flutter_noti/constents/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonStyles {
  static ButtonStyle primaryStyle({
    Color? backgroundColor,
    double borderRadius = 10.0,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
    );
  }

  static ButtonStyle secondaryStyle({
    Color backgroundColor = Colors.white,
    Color borderColor = Colors.grey,
    double borderRadius = 10.0,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor),
      ),
      padding: padding,
    );
  }

  static ButtonStyle outlinedStyle({
    Color borderColor = Colors.grey,
    double borderRadius = 10.0,
    EdgeInsetsGeometry? padding,
  }) {
    return OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      side: BorderSide(color: borderColor),
      padding: padding,
    );
  }

  static ButtonStyle textStyle({
    EdgeInsetsGeometry? padding,
  }) {
    return TextButton.styleFrom(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }

  static TextStyle buttonTextStyle({
    double fontSize = 16.0,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return AppTextStyle.oxygen(
      fontSize: fontSize.sp,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
