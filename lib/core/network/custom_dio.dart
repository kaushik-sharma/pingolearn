import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../di.dart';
import '../helpers/ui_helpers.dart';
import 'network_info.dart';

class CustomDio {
  CustomDio._();

  static final CustomDio instance = CustomDio._();

  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    validateStatus: (status) => true,
    sendTimeout: const Duration(minutes: 5),
    connectTimeout: const Duration(minutes: 5),
    receiveTimeout: const Duration(minutes: 5),
  );

  static final List<Interceptor> _interceptors = [
    if (kDebugMode)
      PrettyDioLogger(
        request: true,
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ),
    _RetryInterceptor(),
  ];

  final Dio _dio = Dio(_baseOptions)..interceptors.addAll(_interceptors);

  final Dio _retryDio = Dio(_baseOptions)
    ..interceptors.addAll(
      _interceptors.where((element) => element is! _RetryInterceptor),
    );

  Dio get dio => _dio;

  Dio get retryDio => _retryDio;
}

class _RetryInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    const int maxRetryCount = 3;
    const Duration retryDelay = Duration(seconds: 5);

    for (int i = 0; i < maxRetryCount; i++) {
      final isConnected = await sl<NetworkInfo>().isConnected;
      if (isConnected) {
        handler.next(options);
        return;
      }

      log('Rechecking for Internet connection in ${retryDelay.inSeconds} seconds...');
      await Future.delayed(retryDelay);
    }

    handler.resolve(Response(
      requestOptions: options,
      data: [],
      statusCode: 503,
      statusMessage: 'No Internet Connection',
    ));
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    void showSnackBar() {
      UiHelpers.showSnackBar('Some error occurred.', mode: SnackBarMode.error);
    }

    Future<void> handleError(Response response) async {
      showSnackBar();
      handler.resolve(response);
    }

    void handleSuccess(Response response) {
      handler.next(response);
    }

    if (response.statusCode! == 200) {
      handleSuccess(response);
      return;
    }

    if (response.statusCode! < 500) {
      handleError(response);
      return;
    }

    final retryDio = CustomDio.instance.retryDio;

    const int maxRetryCount = 3;
    const List<Duration> retryDelays = [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ];

    Response res = response;

    for (int i = 0; i < maxRetryCount; i++) {
      final delay = retryDelays[i];
      log('Retrying request "${res.requestOptions.path}" in ${delay.inSeconds} second(s)...');
      await Future.delayed(delay);

      res = await retryDio.request(
        res.requestOptions.path,
        data: res.requestOptions.data,
        cancelToken: res.requestOptions.cancelToken,
        onReceiveProgress: res.requestOptions.onReceiveProgress,
        onSendProgress: res.requestOptions.onSendProgress,
        queryParameters: res.requestOptions.queryParameters,
        options: Options(
          sendTimeout: res.requestOptions.sendTimeout,
          receiveTimeout: res.requestOptions.receiveTimeout,
          contentType: res.requestOptions.contentType,
          extra: res.requestOptions.extra,
          followRedirects: res.requestOptions.followRedirects,
          headers: res.requestOptions.headers,
          listFormat: res.requestOptions.listFormat,
          maxRedirects: res.requestOptions.maxRedirects,
          method: res.requestOptions.method,
          persistentConnection: res.requestOptions.persistentConnection,
          receiveDataWhenStatusError:
              res.requestOptions.receiveDataWhenStatusError,
          requestEncoder: res.requestOptions.requestEncoder,
          responseDecoder: res.requestOptions.responseDecoder,
          responseType: res.requestOptions.responseType,
          validateStatus: res.requestOptions.validateStatus,
          preserveHeaderCase: res.requestOptions.preserveHeaderCase,
        ),
      );

      if (res.statusCode! == 200) {
        handleSuccess(res);
        return;
      }

      if (res.statusCode! < 500) {
        handleError(res);
        return;
      }
    }

    handleError(res);
  }

  @override
  void onError(DioException exception, ErrorInterceptorHandler handler) {
    if (exception.message != null) {
      UiHelpers.showSnackBar(exception.message!, mode: SnackBarMode.error);
    }
    handler.reject(exception);
  }
}
