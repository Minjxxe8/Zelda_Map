import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zelda_map/ui/groups/widgets/all_group_list_view.dart';
import 'package:zelda_map/ui/groups/widgets/my_group_list_view.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group-provider.dart';
import '../../repository/group_repository.dart';

class GroupsHubScreen extends ConsumerStatefulWidget {
  const GroupsHubScreen({super.key});

  @override
  ConsumerState<GroupsHubScreen> createState() => _GroupsHubScreenState();
}

class _GroupsHubScreenState extends ConsumerState<GroupsHubScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  void _createGroup() async {
    final name = _groupNameController.text.trim();
    final user = ref.read(authProvider).user;

    if (name.isNotEmpty && user != null) {
      await GroupRepository().createGroup(name, user.id);
      _groupNameController.clear();

      ref.invalidate(allGroupsProvider);
      ref.invalidate(myGroupsProvider(user.id));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Groupe '$name' créé ! 🚀")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: "Nom du nouveau groupe...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _createGroup,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
              ],
            ),
          ),

          const TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: "Mes Groupes"),
              Tab(text: "Découvrir"),
            ],
          ),

          Expanded(
            child: TabBarView(
              children: [
                MyGroupsList(),
                AllGroupsDiscovery(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
