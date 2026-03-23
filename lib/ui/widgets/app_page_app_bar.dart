import 'package:flutter/material.dart';
import '../feed/widgets/app_colors.dart';

class AppPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;

  const AppPageAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? kBackground,
      foregroundColor: foregroundColor ?? kTextPrimary,
      iconTheme: iconTheme ?? const IconThemeData(color: kTextPrimary),
      titleSpacing: 16,
      centerTitle: centerTitle,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: kTextPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: _HeaderLogo(),
        ),
      ],
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'lib/images/Logo-LesCopines.png',
        height: 70,
        fit: BoxFit.contain,
      ),
    );
  }
}
