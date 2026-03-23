import 'package:flutter/material.dart';
import '../../feed/widgets/app_colors.dart';
import 'photo_grid_tile.dart';

class ProfileShowcase extends StatelessWidget {
  final String username;
  final String? email;
  final List<Map<String, dynamic>> photos;
  final bool isOwnProfile;
  final int likesGiven;
  final Widget? footer;
  final VoidCallback? onPrimaryAction;
  final String primaryActionLabel;

  const ProfileShowcase({
    super.key,
    required this.username,
    required this.photos,
    required this.isOwnProfile,
    required this.likesGiven,
    this.email,
    this.footer,
    this.onPrimaryAction,
    this.primaryActionLabel = 'Suivre',
  });

  @override
  Widget build(BuildContext context) {
    final stats = _ProfileStats.fromPhotos(photos);
    final memberSince = stats.memberSince;

    return SafeArea(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopRow(
                    username: username,
                    email: email,
                    isOwnProfile: isOwnProfile,
                    onPrimaryAction: onPrimaryAction,
                    primaryActionLabel: primaryActionLabel,
                  ),
                  const SizedBox(height: 18),
                  _AvatarStatsRow(
                    username: username,
                    hasPostedToday: stats.hasPostedToday,
                    totalPhotos: stats.totalPhotos,
                    totalLikesReceived: stats.totalLikesReceived,
                    memberSince: memberSince,
                  ),
                  const SizedBox(height: 12),
                  const _Bio(),
                  const SizedBox(height: 16),
                  _StreakCard(
                    streak: stats.currentStreak,
                    bestStreak: stats.bestStreak,
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: _SectionHeader(title: 'Cette semaine'),
          ),
          SliverToBoxAdapter(
            child: _WeekStrip(entries: _buildWeekEntries(photos)),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Toutes les photos',
            ),
          ),
          _PhotoGrid(entries: photos),
          if (footer != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: footer!,
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  final String username;
  final String? email;
  final bool isOwnProfile;
  final VoidCallback? onPrimaryAction;
  final String primaryActionLabel;

  const _TopRow({
    required this.username,
    this.email,
    required this.isOwnProfile,
    this.onPrimaryAction,
    required this.primaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 28,
                  color: kTextPrimary,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'serif',
                  letterSpacing: -0.4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (email != null && email!.isNotEmpty)
                Text(
                  email!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: kTextPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        isOwnProfile
            ? Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: kSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFFCCCCCC),
                  size: 18,
                ),
              )
            : GestureDetector(
                onTap: onPrimaryAction,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: kAccent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kAccent, width: 0.5),
                  ),
                  child: Text(
                    primaryActionLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kAccentDark,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class _AvatarStatsRow extends StatelessWidget {
  final String username;
  final bool hasPostedToday;
  final int totalPhotos;
  final int totalLikesReceived;
  final DateTime memberSince;

  const _AvatarStatsRow({
    required this.username,
    required this.hasPostedToday,
    required this.totalPhotos,
    required this.totalLikesReceived,
    required this.memberSince,
  });

  String _formatDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    return '$day/$month/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(
          username: username,
          hasPostedToday: hasPostedToday,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(value: '$totalPhotos', label: 'Photos'),
              _StatItem(value: '$totalLikesReceived', label: 'Likes'),
              _StatItem(value: _formatDate(memberSince), label: 'Cree le'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String username;
  final bool hasPostedToday;

  const _Avatar({
    required this.username,
    required this.hasPostedToday,
  });

  @override
  Widget build(BuildContext context) {
    final initials = username.isEmpty ? '?' : username[0].toUpperCase();

    return Stack(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hasPostedToday
                ? const LinearGradient(
                    colors: [kAccent, Color(0xFFC4A45A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: hasPostedToday
                ? null
                : Border.all(color: kSurface, width: 2),
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kSurface,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: kAccent,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        ),
        if (hasPostedToday)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80),
                shape: BoxShape.circle,
                border: Border.all(color: kBackground, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            color: kTextSecondary,
            letterSpacing: 0.8,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Bio extends StatelessWidget {
  const _Bio();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Capturer l'instant, chaque jour sans exception.",
      style: TextStyle(
        fontSize: 13,
        color: Color(0xFF888888),
        height: 1.5,
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;
  final int bestStreak;

  const _StreakCard({
    required this.streak,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kAccentDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kAccentBorder, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: kAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bolt, color: kAccent, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Serie en cours',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kAccent,
                    ),
                  ),
                  Text(
                    'record : $bestStreak jours',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B5A20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '$streak',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: kAccent,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          color: kTextSecondary,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  final List<_WeekEntry> entries;

  const _WeekStrip({required this.entries});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => _WeekDay(entry: entries[i]),
      ),
    );
  }
}

class _WeekDay extends StatelessWidget {
  final _WeekEntry entry;

  const _WeekDay({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          entry.label,
          style: TextStyle(
            fontSize: 9,
            color: entry.isToday ? kAccent : kTextSecondary,
            fontWeight: entry.isToday ? FontWeight.w600 : FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: entry.isToday
                  ? kAccent
                  : entry.isPosted
                      ? kAccent.withOpacity(0.4)
                      : Colors.transparent,
              width: entry.isToday ? 1.5 : 1,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: entry.isPosted
              ? Image.network(
                  entry.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 14,
                      color: kTextSecondary,
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: 22,
                    height: 1,
                    color: kTextSecondary,
                    transform: Matrix4.rotationZ(-0.7),
                  ),
                ),
        ),
      ],
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const _PhotoGrid({required this.entries});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, i) => _GridCell(entry: entries[i]),
        childCount: entries.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _GridCell({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoGridTile(photo: entry),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xAA000000)],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 5),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white70, size: 11),
                const SizedBox(width: 3),
                Text(
                  '${entry['likes_count'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileStats {
  final int totalPhotos;
  final int totalLikesReceived;
  final int currentStreak;
  final int bestStreak;
  final bool hasPostedToday;
  final DateTime memberSince;

  const _ProfileStats({
    required this.totalPhotos,
    required this.totalLikesReceived,
    required this.currentStreak,
    required this.bestStreak,
    required this.hasPostedToday,
    required this.memberSince,
  });

  factory _ProfileStats.fromPhotos(List<Map<String, dynamic>> photos) {
    final parsedDates = photos
        .map((photo) => DateTime.tryParse('${photo['created_at']}'))
        .whereType<DateTime>()
        .map((date) => date.toLocal())
        .toList()
      ..sort();

    final normalizedDays = parsedDates
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);
    var streak = 0;

    for (final day in normalizedDays) {
      if (day == cursor) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (streak == 0 &&
          day == cursor.subtract(const Duration(days: 1))) {
        streak++;
        cursor = day.subtract(const Duration(days: 1));
      } else if (day.isBefore(cursor)) {
        break;
      }
    }

    final hasPostedToday = normalizedDays.contains(
      DateTime(today.year, today.month, today.day),
    );

    final totalLikesReceived = photos.fold<int>(
      0,
      (sum, photo) => sum + ((photo['likes_count'] as int?) ?? 0),
    );

    return _ProfileStats(
      totalPhotos: photos.length,
      totalLikesReceived: totalLikesReceived,
      currentStreak: streak,
      bestStreak: streak,
      hasPostedToday: hasPostedToday,
      memberSince: parsedDates.isEmpty ? today : parsedDates.first,
    );
  }
}

class _WeekEntry {
  final String label;
  final String? imageUrl;
  final bool isToday;

  const _WeekEntry({
    required this.label,
    required this.imageUrl,
    required this.isToday,
  });

  bool get isPosted => imageUrl != null && imageUrl!.isNotEmpty;
}

List<_WeekEntry> _buildWeekEntries(List<Map<String, dynamic>> photos) {
  const labels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Auj.'];
  final now = DateTime.now();
  final weekDays = List.generate(
    7,
    (index) => DateTime(now.year, now.month, now.day - (6 - index)),
  );

  String key(DateTime date) => '${date.year}-${date.month}-${date.day}';

  final photosByDay = <String, Map<String, dynamic>>{};
  for (final photo in photos) {
    final date = DateTime.tryParse('${photo['created_at']}')?.toLocal();
    if (date == null) {
      continue;
    }
    final normalized = DateTime(date.year, date.month, date.day);
    photosByDay.putIfAbsent(key(normalized), () => photo);
  }

  return List.generate(7, (index) {
    final day = weekDays[index];
    final photo = photosByDay[key(day)];
    return _WeekEntry(
      label: labels[index],
      imageUrl: photo?['image_url'] as String?,
      isToday: index == 6,
    );
  });
}
