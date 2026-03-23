import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'countdown_time.dart';

class FeedHeader extends StatelessWidget {
  final String username;

  const FeedHeader({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nextPhotoTime = DateTime(now.year, now.month, now.day + 1);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSurface,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue $username',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Voici les photos postees aujourd hui. Tu peux voir qui a publie, a quelle heure et liker directement depuis l accueil.',
            style: TextStyle(color: kTextSecondary),
          ),
          const SizedBox(height: 16),
          CountdownTimer(nextPhotoTime: nextPhotoTime),
        ],
      ),
    );
  }
}
