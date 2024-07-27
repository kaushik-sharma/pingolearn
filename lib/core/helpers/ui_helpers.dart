import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../router_config/router_config.dart';

enum SnackBarMode {
  info(Colors.blue),
  success(Colors.green),
  error(Colors.red),
  warning(Colors.amber);

  final Color primaryColor;

  const SnackBarMode(this.primaryColor);
}

class UiHelpers {
  static void removeFocus() =>
      FocusScope.of(kContext).requestFocus(FocusNode());

  static void showSnackBar(String text, {required SnackBarMode mode}) {
    kScaffoldMessengerKey.currentState!.clearSnackBars();
    kScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        margin: EdgeInsets.symmetric(horizontal: 10.w).copyWith(
          bottom: 40.h,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        backgroundColor: mode.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide.none,
        ),
        content: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
