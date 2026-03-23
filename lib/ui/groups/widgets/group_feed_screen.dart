import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zelda_map/ui/groups/widgets/show_memeber_view.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/group-provider.dart';
import '../../../repository/group_repository.dart';
class GroupFeedScreen extends ConsumerWidget {
  final Map<String, dynamic> group;
  const GroupFeedScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(groupPhotosProvider(group['id']));
    final userId = ref.watch(authProvider).user?.id;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(group['name']),
            const Text("Classement par votes ⭐", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            onPressed: () => showMembersSheet(context, ref, group['id']),
            tooltip: "Voir les membres",
          ),
        ],
      ),
      body: photosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Erreur : $err")),
        data: (photos) {
          if (photos.isEmpty) {
            return const Center(child: Text("Aucune photo pour le moment. Soyez le premier ! 📸"));
          }

          return ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final username = photo['profiles']['username'] ?? "Utilisateur inconnu";

              // On récupère le nombre de votes depuis la jointure SQL
              final voteCount = (photo['group_votes'] as List).isNotEmpty
                  ? photo['group_votes'][0]['count']
                  : 0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Text(username[0].toUpperCase())),
                      title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Posté à ${photo['created_at'].toString().substring(11, 16)}"),
                      // Affichage de la médaille pour le top 1
                      trailing: index == 0 ? const Icon(Icons.emoji_events, color: Colors.amber) : null,
                    ),
                    Image.network(
                      photo['image_url'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              photo['caption'] ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          // --- SECTION VOTE ---
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.star_border, color: Colors.amber, size: 30),
                                onPressed: () async {
                                  if (userId == null) return;

                                  // 1. Vérifier si l'user peut voter
                                  final repo = GroupRepository();
                                  final canVote = await repo.canVoteToday(userId, group['id']);

                                  if (canVote) {
                                    // 2. Enregistrer le vote
                                    await repo.voteForPhoto(userId, group['id'], photo['id']);

                                    // 3. Rafraîchir le flux (le tri changera automatiquement)
                                    ref.invalidate(groupPhotosProvider(group['id']));

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Vote pris en compte ! ⭐"))
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Tu as déjà voté aujourd'hui ! 🔒"))
                                      );
                                    }
                                  }
                                },
                              ),
                              Text(
                                "$voteCount",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}