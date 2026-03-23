import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/photo_provider.dart';
import 'widgets/feed_empty_state.dart';
import 'widgets/feed_error_state.dart';
import 'widgets/feed_header.dart';
import 'widgets/feed_post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final username = user?.username ?? 'aventuriere';
    final dailyPosts = ref.watch(dailyFeedProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dailyFeedProvider);
        await ref.read(dailyFeedProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          FeedHeader(username: username),
          const SizedBox(height: 24),
          Text(
            'Photos du jour',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          dailyPosts.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => FeedErrorState(error: error),
            data: (posts) {
              if (posts.isEmpty) {
                return const FeedEmptyState();
              }

              return Column(
                children: posts
                    .map(
                      (post) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FeedPostCard(post: post),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
