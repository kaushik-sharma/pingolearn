import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_comments_response_model.freezed.dart';
part 'get_comments_response_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required final int postId,
    required final int id,
    required final String name,
    required final String email,
    required final String body,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
