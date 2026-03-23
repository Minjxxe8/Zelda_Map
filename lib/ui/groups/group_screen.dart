import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zelda_map/ui/groups/widgets/all_group_list_view.dart';
import 'package:zelda_map/ui/groups/widgets/my_group_list_view.dart';

class GroupsHubScreen extends ConsumerWidget {
  const GroupsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Mes Groupes"),
              Tab(text: "Découvrir"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                const MyGroupsList(),
                const AllGroupsDiscovery(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

