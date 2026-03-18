import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> photo;

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.parse(photo['created_at']).toLocal();
    final String timeStr = DateFormat('HH:mm').format(date);
    final String dateStr = DateFormat('dd/MM/yyyy').format(date);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Image.network(photo['image_url'], fit: Navigator.canPop(context) ? BoxFit.contain : BoxFit.cover),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Prise à $timeStr", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(dateStr, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(photo['caption'] ?? "Pas de légende", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Chip(label: Text("Mode: ${photo['mode']}")),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}