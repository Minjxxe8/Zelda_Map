import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zelda_map/ui/profile/widgets/delete_account_btn.dart';
import 'package:zelda_map/ui/profile/widgets/logout_btn.dart';
import 'package:zelda_map/ui/profile/widgets/photo_grid.dart';
import 'package:zelda_map/ui/profile/widgets/photo_upload_btn.dart';
import 'package:zelda_map/ui/profile/widgets/profile_header.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/photo_provider.dart';

class ProfileScreen extends ConsumerWidget {
  final bool embedded;

  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    final body = user == null
        ? const Center(child: Text("Aucune session active"))
        : RefreshIndicator(
        onRefresh: () => ref.refresh(userPhotosProvider(user.id).future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 30),
              const Divider(),
              PhotoUploadButton(userId: user.id),
              const SizedBox(height: 30),
              PhotoGrid(userId: user.id),
              const SizedBox(height: 50),
              const LogoutButton(),
              const DeleteAccountButton(),
            ],
          ),
        ),
      );

    if (embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil"), centerTitle: true),
      body: body,
    );
  }
}
