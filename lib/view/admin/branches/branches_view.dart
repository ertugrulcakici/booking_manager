import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/branches/branches_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
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
      floatingActionButton: _fab(),
      appBar: AppBar(title: Text(LocaleKeys.branches_title.tr())),
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
      return Center(child: Text(LocaleKeys.branches_no_branches.tr()));
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
            title: Text(LocaleKeys.branches_delete_branch_title.tr()),
            content: Text(LocaleKeys.branches_delete_branch_content.tr()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(LocaleKeys.cancel.tr())),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(provider).deleteBranch(branch);
                  },
                  child: Text(LocaleKeys.delete.tr())),
            ],
          );
        });
  }

  Widget _fab() {
    return FloatingActionButton.extended(
      onPressed: ref.read(provider).addBranchNavigate,
      label: Text(LocaleKeys.branches_create_branch.tr()),
      icon: const Icon(Icons.add),
    );
  }
}
