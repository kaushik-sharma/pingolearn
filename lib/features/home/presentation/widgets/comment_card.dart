import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/get_comments_response_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool maskEmail;

  const CommentCard(
      {super.key, required this.comment, required this.maskEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          12.horizontalSpace,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleAndDescription('Name: ', comment.name),
                _buildTitleAndDescription('Email: ', _email),
                Text(
                  comment.body,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 21.sp / 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _email {
    if (!maskEmail) return comment.email;

    return _maskEmail(comment.email);
  }

  String _maskEmail(String email) {
    // Split the email into username and domain
    final parts = email.split('@');
    if (parts.length != 2) {
      throw ArgumentError('Invalid email format');
    }

    final username = parts[0];
    final domain = parts[1];

    // Ensure the username has enough characters to mask
    if (username.length <= 3) {
      return email;
    }

    // Mask the username except the first 3 characters
    final maskedUsername =
        username.substring(0, 3) + '·' * (username.length - 3);

    // Construct the masked email
    final maskedEmail = '$maskedUsername@$domain';

    return maskedEmail;
  }

  Widget _buildTitleAndDescription(String title, String desc) => Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                )),
            TextSpan(
                text: desc,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                )),
          ],
          style: TextStyle(
            fontSize: 14.sp,
            height: 21.sp / 14.sp,
          ),
        ),
      );

  Widget _buildAvatar() => CircleAvatar(
        minRadius: 23.r,
        maxRadius: 23.r,
        backgroundColor: const Color(0xFFCED3DC),
        foregroundColor: Colors.black,
        child: Center(
          child: Text(
            comment.name.characters.first.toUpperCase(),
            style: TextStyle(
              fontSize: 16.sp,
              height: 24.sp / 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
