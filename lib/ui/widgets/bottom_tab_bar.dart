import 'package:flutter/material.dart';
import '../feed/widgets/app_colors.dart';

class BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onTap;

  const BottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabItem(
            icon: Icons.home_outlined,
            label: 'Accueil',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _TabItem(
            icon: Icons.person_search_outlined,
            label: 'Groupes',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _TabItem(
            icon: Icons.camera_alt_outlined,
            label: 'Appareil photo',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _TabItem(
            icon: Icons.person_outline,
            label: 'Profil',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? kAccent : const Color(0xFF555555);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(bottom: 2),
                decoration: const BoxDecoration(
                  color: kAccent,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 6),
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(fontSize: 9, color: color, letterSpacing: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}
