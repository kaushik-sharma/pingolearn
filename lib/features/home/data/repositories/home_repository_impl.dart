import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../core/failures/failure.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/get_comments_response_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource datasource;
  final FirebaseRemoteConfig remoteConfig;

  const HomeRepositoryImpl(
      {required this.datasource, required this.remoteConfig});

  @override
  Future<Either<Failure, List<CommentModel>>> getComments() async {
    try {
      final result = await Future.wait([
        remoteConfig.fetchAndActivate(),
        datasource.getComments(),
      ]);
      return Right(result[1] as List<CommentModel>);
    } catch (e) {
      log(e.toString());
      return const Left(Failure('Failed to get comments.'));
    }
  }
}
