import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../data/models/get_comments_response_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CommentModel>>> getComments();
}
