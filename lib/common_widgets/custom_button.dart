import 'package:flutter/material.dart';
import 'package:flutter_noti/constents/button_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String? iconPath;
  final double? width;
  final double? height;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final TextStyle? textStyle;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.iconPath,
    this.width,
    this.height = 56.0,
    this.iconSize = 24.0,
    this.padding,
    this.borderRadius = 10.0,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyles.primaryStyle(
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          padding: padding,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle ?? ButtonStyles.buttonTextStyle(),
            ),
            if (iconPath != null) ...[
              SizedBox(width: 8.w),
              Image.asset(
                iconPath!,
                width: iconSize.w,
                height: iconSize.h,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
