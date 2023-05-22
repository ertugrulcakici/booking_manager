import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/product/models/invitation_model.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/invitations/invitations_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
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
        appBar: AppBar(title: Text(LocaleKeys.invitations_title.tr())),
        body: _body());
  }

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.invitations_create_invitation.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _invitationForm(),
            const Divider(),
            Text(
              LocaleKeys.invitations_all_invitations.tr(),
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
        decoration:
            InputDecoration(labelText: LocaleKeys.invitations_for_who.tr()),
      ),
    ]));
  }

  Widget _invitationList() {
    if (ref.watch(provider).isLoading) {
      return const Expanded(child: CustomLoadingWidget());
    }
    if (ref.watch(provider).invitations.isEmpty) {
      return Expanded(
          child:
              Center(child: Text(LocaleKeys.invitations_no_invitations.tr())));
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
                          children: [
                            const Icon(Icons.delete),
                            Text(LocaleKeys.delete.tr())
                          ],
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
                    PopupHelper.instance.showSnackBar(
                        message:
                            LocaleKeys.invitations_copied_to_clipboard.tr());
                  },
                ),
                title: Text(LocaleKeys.invitations_for_whom
                    .tr(args: [invitation.forWhomName])),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocaleKeys.invitations_invitation_code
                        .tr(args: [invitation.code])),
                    Text(LocaleKeys.invitations_created_at.tr(args: [
                      invitation.createdDate.toDateTime().formattedDateTime
                    ])),
                    Text(LocaleKeys.invitations_is_used.tr(args: [
                      invitation.isUsed
                          ? LocaleKeys.yes.tr()
                          : LocaleKeys.no.tr()
                    ])),
                    Text(LocaleKeys.invitations_used_date.tr(args: [
                      invitation.usedDate?.toDateTime().formattedDateTime ?? "-"
                    ])),
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
    PopupHelper.instance.showOkCancelDialog(
        title: LocaleKeys.invitations_delete_invitation_title.tr(),
        content: LocaleKeys.invitations_delete_invitation_content.tr(),
        onOk: () {
          ref.read(provider).deleteInvitation(invitation);
        });
  }
}
