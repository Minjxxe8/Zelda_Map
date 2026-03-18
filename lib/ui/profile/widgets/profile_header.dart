import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(user.username,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(user.email,
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}