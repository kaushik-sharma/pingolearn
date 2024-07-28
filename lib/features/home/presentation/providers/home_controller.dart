import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/models/get_comments_response_model.dart';
import '../../domain/usecases/home_usecases.dart';

class HomeController extends ChangeNotifier {
  final GetCommentsUseCase getCommentsUseCase;
  final FirebaseRemoteConfig remoteConfig;

  HomeController({
    required this.getCommentsUseCase,
    required this.remoteConfig,
  });

  final _comments = <CommentModel>[];
  bool _isLoading = true;

  List<CommentModel> get comments => [..._comments];

  bool get isLoading => _isLoading;

  bool get maskEmail => remoteConfig.getBool('mask_email');

  Future<void> getComments() async {
    _isLoading = true;
    notifyListeners();

    final result = await getCommentsUseCase(const NoParams());
    result.fold<void>((left) {}, (right) {
      _comments.clear();
      _comments.addAll(right);
    });

    _isLoading = false;
    notifyListeners();
  }
}
