import 'package:flutter/material.dart';
import '../../data/models/sign_up_request_model.dart';

import '../../data/models/sign_in_request_model.dart';
import '../../domain/usecases/auth_usecases.dart';

enum AuthMode { signIn, signUp }

class AuthController extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;

  AuthController({
    required this.signUpUseCase,
    required this.signInUseCase,
  });

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.signUp;
  final _scrollController = ScrollController();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get nameController => _nameController;
  bool get isLoading => _isLoading;
  AuthMode get authMode => _authMode;
  ScrollController get scrollController => _scrollController;

  void toggleAuthMode() {
    _authMode =
        _authMode == AuthMode.signUp ? AuthMode.signIn : AuthMode.signUp;
    _formKey.currentState!.reset();
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    notifyListeners();
  }

  bool _validateForm() {
    return _formKey.currentState!.validate();
  }

  Future<bool?> signUp() async {
    if (!_validateForm()) return null;

    _isLoading = true;
    notifyListeners();
    final result = await signUpUseCase(
      SignUpRequestModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
      ),
    );
    _isLoading = false;
    notifyListeners();
    return result.fold<bool>((left) => false, (right) => true);
  }

  Future<bool?> signIn() async {
    if (!_validateForm()) return null;

    _isLoading = true;
    notifyListeners();
    final result = await signInUseCase(
      SignInRequestModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
    _isLoading = false;
    notifyListeners();
    return result.fold<bool>((left) => false, (right) => true);
  }

  void scrollToBottom() async {
    await Future.delayed(Duration(milliseconds: 200));
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent
    , duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
