import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/user_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/invitations/invitations_view.dart';
import 'package:bookingmanager/view/admin/workers/workers_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkersView extends ConsumerStatefulWidget {
  const WorkersView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WorkersViewState();
}

class _WorkersViewState extends ConsumerState<WorkersView> {
  late final ChangeNotifierProvider<WorkersNotifier> provider =
      ChangeNotifierProvider((ref) => WorkersNotifier());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(provider).getUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "invitations",
        onPressed: () {
          NavigationService.toPage(const InvitationsView());
        },
        label: const Text("Invitations"),
        icon: const Icon(Icons.list),
      ),
      appBar: AppBar(
        title: const Text("Workers"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return const CustomLoadingWidget();
    }

    if (ref.watch(provider).isError) {
      return CustomErrorWidget(
          errorMessage: ref.watch(provider).errorMessage,
          onPressed: ref.read(provider).getUsers);
    }
    return ListView.builder(
      itemCount: ref.watch(provider).users.length,
      itemBuilder: (context, index) {
        UserModel user = ref.watch(provider).users[index];
        return Card(
          child: ListTile(
              title: Text(user.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteUser(user);
                },
              )),
        );
      },
    );
  }

  Future<void> _deleteUser(UserModel user) async {
    bool? delete = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete user"),
            content: const Text("Are you sure you want to delete this user?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Delete")),
            ],
          );
        });
    if (delete == true) {
      ref.read(provider).deleteUser(user);
    }
  }
}
