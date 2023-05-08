import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/branches/branches_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BranchesView extends ConsumerStatefulWidget {
  const BranchesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BranchesViewState();
}

class _BranchesViewState extends ConsumerState<BranchesView> {
  ChangeNotifierProvider<BranchesNotifier> provider =
      ChangeNotifierProvider((ref) => BranchesNotifier());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(provider).getData().then((value) {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ref.read(provider).addBranchNavigate,
        label: const Text("Add branch"),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("Branches")),
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
          onPressed: ref.read(provider).getData);
    }
    return _content();
  }

  Widget _content() {
    if (ref.watch(provider).branches.isEmpty) {
      return const Center(child: Text("No branches"));
    }

    return ListView.separated(
        itemBuilder: (context, index) {
          BranchModel branch = ref.watch(provider).branches[index];
          return _branchItem(branch);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: ref.watch(provider).branches.length);
  }

  Widget _branchItem(BranchModel branch) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.edit),
        title: Text(branch.name),
        onTap: () {
          ref.read(provider).editBranch(branch);
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteBranch(branch),
        ),
      ),
    );
  }

  Future<void> _deleteBranch(BranchModel branch) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete branch"),
            content: const Text("Are you sure you want to delete this branch?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(provider).deleteBranch(branch);
                  },
                  child: const Text("Delete")),
            ],
          );
        });
  }
}
