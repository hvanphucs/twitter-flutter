import 'package:twitter_flutter/models/user_model.dart';

class CommentModel {
  String key;
  String parentId;
  String description;
  UserModel user;
  int likeCount;
  int commentCount;
  String createdAt;
  String? imagePath;

  CommentModel(
      {required this.key,
      required this.parentId,
      required this.description,
      required this.user,
      this.likeCount = 0,
      this.commentCount = 0,
      this.createdAt = '',
      this.imagePath});

  toJson() {
    return {
      'key': key,
      'parentId': parentId,
      'description': description,
      'user': user.toJson(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': createdAt,
      'imagePath': imagePath,
    };
  }

  static fromJson(Map<String, dynamic> map) {
    return CommentModel(
      key: map['key'],
      parentId: map['parentId'],
      description: map['description'],
      likeCount: map['likeCount'],
      commentCount: map['commentCount'],
      createdAt: map['createdAt'],
      imagePath: map['imagePath'],
      user: UserModel.fromJson(
        map['user'],
      ),
    );
  }
}
