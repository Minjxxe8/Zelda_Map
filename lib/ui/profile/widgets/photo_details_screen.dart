import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/photo_provider.dart';
import '../../../repository/photo_repository.dart';
import '../../widgets/app_page_app_bar.dart';

class PhotoDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> photo;
  const PhotoDetailScreen({super.key, required this.photo});

  @override
  ConsumerState<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends ConsumerState<PhotoDetailScreen> {
  late String currentCaption;

  @override
  void initState() {
    super.initState();
    currentCaption = widget.photo['caption'] ?? "Ajouter une légende...";
  }

  void _editCaption() async {
    final controller = TextEditingController(text: currentCaption);

    final String? newCaption = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Modifier la légende"),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );

    if (newCaption == null || newCaption == currentCaption) return;

    await PhotoRepository().updatePhotoCaption(widget.photo['id'], newCaption);

    setState(() => currentCaption = newCaption);
    ref.invalidate(userPhotosProvider(widget.photo['user_id']));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.parse(widget.photo['created_at']).toLocal();
    final String timeStr = DateFormat('HH:mm').format(date);
    final String dateStr = DateFormat('dd/MM/yyyy').format(date);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppPageAppBar(
        title: 'Photo',
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Image.network(
                widget.photo['image_url'],
                fit: Navigator.canPop(context) ? BoxFit.contain : BoxFit.cover,
              ),
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
                    Text(
                      "Prise à $timeStr",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _editCaption,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          currentCaption,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      const Icon(Icons.edit, size: 16, color: Colors.blueAccent),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Chip(label: Text("Mode: ${widget.photo['mode']}")),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
