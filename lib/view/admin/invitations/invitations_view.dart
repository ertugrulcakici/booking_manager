import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/product/models/invitation_model.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/invitations/invitations_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InvitationsView extends ConsumerStatefulWidget {
  const InvitationsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InvitationsViewState();
}

class _InvitationsViewState extends ConsumerState<InvitationsView> {
  ChangeNotifierProvider<InvitationsNotifier> provider =
      ChangeNotifierProvider((ref) => InvitationsNotifier());

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(provider).getInvitations();
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Invitations")), body: _body());
  }

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Create invitation",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _invitationForm(),
            const Divider(),
            Text(
              "Invitations",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _invitationList()
          ],
        ));
  }

  Widget _invitationForm() {
    return Form(
        child: Column(children: [
      TextField(
        controller: _nameController,
        onSubmitted: (value) {
          ref.read(provider).createInvitation(value);
          _nameController.clear();
        },
        decoration: const InputDecoration(labelText: "For whom"),
      ),
    ]));
  }

  Widget _invitationList() {
    if (ref.watch(provider).isLoading) {
      return const Expanded(child: CustomLoadingWidget());
    }
    if (ref.watch(provider).invitations.isEmpty) {
      return const Expanded(child: Center(child: Text("No invitations")));
    }
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: ref.watch(provider).invitations.length,
        itemBuilder: (context, index) {
          InvitationModel invitation = ref.watch(provider).invitations[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _deleteInvitation(invitation);
                    },
                    child: Container(
                      color: Colors.red,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.delete), Text("Delete")],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            child: Card(
              child: ListTile(
                onLongPress: () {
                  _deleteInvitation(invitation);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: invitation.code));
                    PopupHelper.instance
                        .showSnackBar(message: "Copied to clipboard");
                  },
                ),
                title: Text("For whom: ${invitation.forWhomName}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Invitation code: ${invitation.code}"),
                    Text(
                        "Created at: ${invitation.createdDate.toDateTime().formattedDateTime}"),
                    Text("Is used: ${invitation.isUsed}"),
                    Text(
                        "Used date: ${invitation.usedDate?.toDateTime().formattedDateTime ?? '-'}")
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteInvitation(InvitationModel invitation) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete invitation"),
            content:
                const Text("Are you sure you want to delete this invitation?"),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(provider).deleteInvitation(invitation);
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              )
            ],
          );
        });
  }
}
