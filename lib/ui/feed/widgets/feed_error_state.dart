import 'package:flutter/material.dart';

class FeedErrorState extends StatelessWidget {
  final Object error;

  const FeedErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impossible de charger les photos du jour.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error.toString()),
          const SizedBox(height: 8),
          const Text(
            'Verifie que les tables profiles et photo_likes existent bien dans Supabase.',
          ),
        ],
      ),
    );
  }
}
