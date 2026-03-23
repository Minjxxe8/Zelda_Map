import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../model/daily_post.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/photo_provider.dart';
import '../../profile/public_profile_screen.dart';

class FeedPostCard extends ConsumerWidget {
  final DailyPost post;

  const FeedPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final photoNotifier = ref.watch(photoProvider);
    final isLiking = photoNotifier.isLiking(post.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PublicProfileScreen(
                            userId: post.userId,
                            username: post.username,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                post.username.isEmpty
                                    ? '?'
                                    : post.username.substring(0, 1).toUpperCase(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(post.postedAt),
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: user == null || isLiking
                          ? null
                          : () => ref
                              .read(photoProvider)
                              .toggleLike(post.id, user.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isLiking)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              Icon(
                                post.isLikedByCurrentUser
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            const SizedBox(width: 6),
                            Text(
                              '${post.likesCount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if ((post.caption ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(post.caption!.trim()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
