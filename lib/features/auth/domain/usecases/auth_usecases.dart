import '../../data/models/sign_in_request_model.dart';
import '../../data/models/sign_up_request_model.dart';

import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<NoParams, SignUpRequestModel> {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, NoParams>> call(SignUpRequestModel model) async {
    return await repository.signUp(model);
  }
}

class SignInUseCase implements UseCase<NoParams, SignInRequestModel> {
  final AuthRepository repository;

  const SignInUseCase(this.repository);

  @override
  Future<Either<Failure, NoParams>> call(SignInRequestModel model) async {
    return await repository.signIn(model);
  }
}

class SignOutUseCase implements UseCase<NoParams, NoParams> {
  final AuthRepository repository;

  const SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, NoParams>> call(NoParams params) async {
    return await repository.signOut();
  }
}
