import 'package:flutter/material.dart';

class DailyPost {
  final String id;
  final String userId;
  final String username;
  final String imageUrl;
  final String? caption;
  final DateTime postedAt;
  // final int likesCount;
  // final bool isLikedByCurrentUser;

  const DailyPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.imageUrl,
    this.caption,
    required this.postedAt,
    // required this.likesCount,
    // this.isLikedByCurrentUser = false,
  });
}
