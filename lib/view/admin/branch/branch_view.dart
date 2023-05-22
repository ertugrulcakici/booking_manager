// ignore_for_file: use_build_context_synchronously

import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/view/admin/branch/branch_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BranchView extends ConsumerStatefulWidget {
  final BranchModel? branch;
  const BranchView({super.key, this.branch});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BranchViewState();
}

class _BranchViewState extends ConsumerState<BranchView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final ChangeNotifierProvider<BranchNotifier> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => BranchNotifier(widget.branch));
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      appBar: AppBar(
          title: Text(widget.branch == null
              ? LocaleKeys.branches_create_branch.tr()
              : LocaleKeys.branch_title_edit.tr())),
      body: _body(),
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      onPressed: () {
        _formKey.currentState?.save();
        ref.read(provider).save();
      },
      child: const Icon(Icons.save),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              onSaved: (newValue) {
                ref.read(provider).formData["name"] = newValue;
              },
              initialValue: ref.watch(provider).formData["name"],
              decoration: InputDecoration(
                labelText: LocaleKeys.branch_branch_name_label.tr(),
                hintText: LocaleKeys.branch_branch_name_hint.tr(),
              ),
            ),
            TextFormField(
              onSaved: (newValue) {
                ref.read(provider).formData["unitPrice"] = num.parse(newValue!);
              },
              initialValue:
                  ref.watch(provider).formData["unitPrice"].toString(),
              decoration: InputDecoration(
                labelText: LocaleKeys.branch_person_price_label.tr(),
                hintText: LocaleKeys.branch_person_price_hint.tr(),
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.branch_add_working_hour.tr()),
              onTap: _addWorkingHour,
              trailing: const Icon(Icons.add),
            ),
            (ref.watch(provider).formData["workingHoursList"] as List).isEmpty
                ? Text(LocaleKeys.branch_empty_working_hours.tr())
                : const SizedBox(height: 0),
            Expanded(
              child: ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final items = (ref
                        .read(provider)
                        .formData["workingHoursList"] as List);
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);
                  });
                },
                shrinkWrap: true,
                itemCount:
                    (ref.watch(provider).formData["workingHoursList"] as List)
                        .length,
                itemBuilder: (context, index) {
                  final workingHour = (ref
                      .watch(provider)
                      .formData["workingHoursList"] as List)[index];
                  return ListTile(
                    leading: const Icon(Icons.drag_handle),
                    key: ValueKey(workingHour),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          (ref.read(provider).formData["workingHoursList"]
                                  as List)
                              .removeAt(index);
                        });
                      },
                    ),
                    title: Center(
                      child: Text(workingHour),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addWorkingHour() async {
    TimeOfDay? time = await showTimePicker(
        helpText: LocaleKeys.branch_select_time.tr(),
        context: context,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        initialTime: const TimeOfDay(hour: 0, minute: 0));
    if (time != null) {
      if (!ref
          .watch(provider)
          .formData["workingHoursList"]
          .contains(time.formatted)) {
        ref.watch(provider).formData["workingHoursList"].add(time.formatted);
        setState(() {});
      } else {
        PopupHelper.instance.showSnackBar(
            message: LocaleKeys.branch_already_in_list.tr(), error: true);
      }
    }
  }

  Future<void> addBranchProperty() async {}
}

// TODO: farklı sayfaya al

class _TimePickerDialog extends StatefulWidget {
  const _TimePickerDialog();

  @override
  State<_TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  String? workingHour;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.branch_add_working_hour.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          workingHour == null
              ? Text(LocaleKeys.branch_select_time.tr())
              : Text(LocaleKeys.branch_time.tr(args: [workingHour!])),
          ElevatedButton(
              onPressed: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 0, minute: 0),
                );
                if (time != null) {
                  setState(() {
                    workingHour = time.formatted;
                  });
                }
              },
              child: Text(LocaleKeys.branch_select_time.tr())),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text(LocaleKeys.cancel.tr())),
        TextButton(
            onPressed: () {
              Navigator.pop(context, workingHour);
            },
            child: Text(LocaleKeys.add.tr())),
      ],
    );
  }
}
