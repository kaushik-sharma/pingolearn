import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../data/models/sign_in_request_model.dart';
import '../../data/models/sign_up_request_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, NoParams>> signUp(SignUpRequestModel model);

  Future<Either<Failure, NoParams>> signIn(SignInRequestModel model);

  Future<Either<Failure, NoParams>> signOut();
}
