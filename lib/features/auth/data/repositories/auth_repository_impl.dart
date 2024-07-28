import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/services/caching_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/sign_in_request_model.dart';
import '../models/sign_up_request_model.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final CachingService cachingService;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.cachingService,
  });

  @override
  Future<Either<Failure, NoParams>> signUp(SignUpRequestModel model) async {
    try {
      final authToken = await remoteDatasource.signUp(
          model.email, model.password, model.name);
      localDatasource.saveAuthToken(authToken);
      return const Right(NoParams());
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      log(e.toString());
      return Left(Failure(e.message ?? 'Sign-up failed.'));
    } catch (e) {
      log(e.toString());
      return const Left(Failure('Sign-up failed.'));
    }
  }

  @override
  Future<Either<Failure, NoParams>> signIn(SignInRequestModel model) async {
    try {
      final authToken =
          await remoteDatasource.signIn(model.email, model.password);
      localDatasource.saveAuthToken(authToken);
      return const Right(NoParams());
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      log(e.toString());
      return Left(Failure(e.message ?? 'Sign-in failed.'));
    } catch (e) {
      log(e.toString());
      return const Left(Failure('Sign-in failed.'));
    }
  }

  @override
  Future<Either<Failure, NoParams>> signOut() async {
    try {
      await remoteDatasource.signOut();
      cachingService.clear();
      return const Right(NoParams());
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      log(e.toString());
      return const Left(Failure());
    } catch (e) {
      log(e.toString());
      return const Left(Failure());
    }
  }
}
