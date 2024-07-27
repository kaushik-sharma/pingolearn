import 'package:dartz/dartz.dart';
import '../../data/models/get_comments_response_model.dart';
import '../repositories/home_repository.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/usecases/usecase.dart';

class GetCommentsUseCase implements UseCase<List<CommentModel>, NoParams> {
  final HomeRepository repository;

  const GetCommentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CommentModel>>> call(NoParams params) async {
    return await repository.getComments();
  }
}
