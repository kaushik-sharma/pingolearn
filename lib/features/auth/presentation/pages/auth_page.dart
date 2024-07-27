import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/helpers/ui_helpers.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../di.dart';
import '../../../../router_config/router_config.dart';
import '../providers/auth_controller.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (context) => sl<AuthController>(),
      builder: (context, child) => const _AuthPageHandler(),
    );
  }
}

class _AuthPageHandler extends StatefulWidget {
  const _AuthPageHandler();

  @override
  State<_AuthPageHandler> createState() => _AuthPageHandlerState();
}

class _AuthPageHandlerState extends State<_AuthPageHandler> {
  late final _controller = context.read<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
              _controller.authMode == AuthMode.signUp ? 'Sign Up' : 'Sign In'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ListView(
                  children: [
                    100.verticalSpace,
                    _buildForm(),
                    200.verticalSpace,
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCTA(),
                    10.verticalSpace,
                    _buildModeController(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCTA() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 70.w),
        child: CustomButton(
          type: ButtonType.elevated,
          onTap: () async {
            final result = await (_controller.authMode == AuthMode.signUp
                ? _controller.signUp()
                : _controller.signIn());
            if (result == null) return;
            if (!result) {
              UiHelpers.showSnackBar('Authentication failed.',
                  mode: SnackBarMode.error);
              return;
            }
            context.goNamed(Routes.home.name);
          },
          text: _controller.authMode == AuthMode.signUp ? 'Sign Up' : 'Sign In',
          isLoading: _controller.isLoading,
        ),
      );

  Widget _buildForm() => Form(
        key: _controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_controller.authMode == AuthMode.signUp) ...[
              CustomTextField(
                controller: _controller.nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                hintText: 'Name',
              ),
              20.verticalSpace,
            ],
            CustomTextField(
              controller: _controller.emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Invalid email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              hintText: 'Email',
            ),
            20.verticalSpace,
            CustomTextField(
              controller: _controller.passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.none,
              hintText: 'Password',
              obscureText: true,
            ),
          ],
        ),
      );

  Widget _buildModeController() => Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: _controller.authMode == AuthMode.signUp
                  ? 'Already have an account? '
                  : 'New here? ',
            ),
            TextSpan(
              text: _controller.authMode == AuthMode.signUp
                  ? 'Sign In'
                  : 'Sign Up',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  UiHelpers.removeFocus();
                  _controller.toggleAuthMode();
                },
            ),
          ],
          style: TextStyle(
            fontSize: 16.sp,
            height: 24.sp / 16.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
}
