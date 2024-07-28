import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_comments_response_model.dart';

part 'home_remote_datasource.g.dart';

@RestApi()
abstract class HomeRemoteDatasource {
  factory HomeRemoteDatasource(Dio dio) = _HomeRemoteDatasource;

  @GET('/comments')
  Future<List<CommentModel>> getComments();
}
