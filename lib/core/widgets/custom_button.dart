import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../router_config/router_config.dart';

enum ButtonType { elevated, outlined, text }

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final ButtonType type;
  final bool isEnabled;
  final bool isLoading;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.type,
    this.isEnabled = true,
    this.isLoading = false,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ButtonType.elevated => _buildElevatedButton(),
      ButtonType.outlined => _buildOutlinedButton(),
      ButtonType.text => _buildTextButton(),
    };
  }

  Widget _buildElevatedButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: backgroundColor ?? Theme.of(kContext).primaryColor,
            foregroundColor: foregroundColor ?? Colors.white,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledForegroundColor: Colors.grey,
            disabledBackgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: _buildPadding(),
          ),
          onPressed: _onPressed(),
          child: _buildButtonChild(),
        ),
      );

  Widget _buildOutlinedButton() => SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: foregroundColor ?? Colors.black,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const StadiumBorder(),
            padding: _buildPadding(),
            side:
                BorderSide(color: foregroundColor ?? Colors.black, width: 1.r),
          ),
          onPressed: _onPressed(),
          child: _buildButtonChild(),
        ),
      );

  Widget _buildTextButton() => TextButton(
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? Colors.black,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
          padding: _buildPadding(),
        ),
        onPressed: _onPressed(),
        child: _buildButtonChild(),
      );

  Widget _buildButtonChild() => isLoading
      ? SizedBox(
          width: 25.r,
          height: 25.r,
          child: CircularProgressIndicator(
            color: foregroundColor ?? Colors.white,
            strokeWidth: 2.r,
          ),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon!, size: 24.r),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 24.sp / 16.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: 8.w),
              Icon(suffixIcon!, size: 24.r),
            ],
          ],
        );

  EdgeInsets _buildPadding() => EdgeInsets.all(12.r);

  VoidCallback? _onPressed() => isEnabled && !isLoading ? onTap : null;
}
