import 'package:flutter/material.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/auth_usecases.dart';

class SignOutController extends ChangeNotifier {
  final SignOutUseCase signOutUseCase;

  SignOutController({required this.signOutUseCase});

  Future<void> signOut() async {
    await signOutUseCase(const NoParams());
    notifyListeners();
  }
}
