import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'core/services/caching_service.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/domain/usecases/home_usecases.dart';
import 'features/home/presentation/providers/home_controller.dart';

import 'core/network/custom_dio.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/providers/auth_controller.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';

final GetIt sl = GetIt.instance;

void initialize() {
  _injectExternal();
  _injectCore();
  _injectAuth();
  _injectHome();
}

void _injectHome() {
  sl.registerLazySingleton<HomeRemoteDatasource>(
      () => HomeRemoteDatasource(sl<Dio>()));

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        datasource: sl<HomeRemoteDatasource>(),
        remoteConfig: sl<FirebaseRemoteConfig>(),
      ));

  sl.registerLazySingleton<GetCommentsUseCase>(
      () => GetCommentsUseCase(sl<HomeRepository>()));

  sl.registerFactory<HomeController>(() => HomeController(
      getCommentsUseCase: sl<GetCommentsUseCase>(),
      remoteConfig: sl<FirebaseRemoteConfig>()));
}

void _injectAuth() {
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        firebaseFirestore: FirebaseFirestore.instance,
      ));
  sl.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasource(service: sl<CachingService>()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDatasource: sl<AuthRemoteDatasource>(),
        localDatasource: sl<AuthLocalDatasource>(),
        cachingService: sl<CachingService>(),
      ));

  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(sl<AuthRepository>()));

  sl.registerFactory<AuthController>(() => AuthController(
        signUpUseCase: sl<SignUpUseCase>(),
        signInUseCase: sl<SignInUseCase>(),
        signOutUseCase: sl<SignOutUseCase>(),
      ));
}

void _injectCore() {
  sl.registerLazySingleton<FirebaseRemoteConfig>(
      () => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton<CachingService>(() => CachingService.instance);
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnection: sl<InternetConnection>()));
  sl.registerLazySingleton<GlobalKey<ScaffoldMessengerState>>(
      () => GlobalKey<ScaffoldMessengerState>());
}

void _injectExternal() {
  sl.registerLazySingleton<Dio>(() => CustomDio.instance.dio);
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
}
