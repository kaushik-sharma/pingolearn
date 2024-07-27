import '../../../../core/services/caching_service.dart';

class AuthLocalDatasource {
  final CachingService service;

  const AuthLocalDatasource({required this.service});

  void saveAuthToken(String authToken) {
    service.saveString('auth_token', authToken);
  }

  bool isAuthenticated() {
    return service.getString('auth_token') != null;
  }
}
