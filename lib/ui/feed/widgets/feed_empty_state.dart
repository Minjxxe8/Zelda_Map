import 'package:flutter/material.dart';

class FeedEmptyState extends StatelessWidget {
  const FeedEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.photo_library_outlined, size: 36),
          SizedBox(height: 12),
          Text(
            'Aucune photo n a ete postee aujourd hui.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
