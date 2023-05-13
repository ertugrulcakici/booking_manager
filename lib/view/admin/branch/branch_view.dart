// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/view/admin/branch/branch_notifier.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _formKey.currentState?.save();
          ref.read(provider).save();
        },
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
          title: Text(widget.branch == null ? "Create branch" : "Edit branch")),
      body: _body(),
    );
  }

  Widget _body() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            onSaved: (newValue) {
              ref.read(provider).formData["name"] = newValue;
            },
            initialValue: ref.watch(provider).formData["name"],
            decoration: const InputDecoration(
              labelText: 'Branch name',
              hintText: "Enter branch name",
            ),
          ),
          TextFormField(
            onSaved: (newValue) {
              ref.read(provider).formData["unitPrice"] = num.parse(newValue!);
            },
            initialValue: ref.watch(provider).formData["unitPrice"].toString(),
            decoration: const InputDecoration(
              labelText: 'Person price',
              hintText: "Enter person price",
            ),
          ),
          ListTile(
            title: const Text("Add working hours"),
            onTap: _addWorkingHour,
            trailing: const Icon(Icons.add),
          ),
          (ref.watch(provider).formData["workingHoursList"] as List).isEmpty
              ? const Text("There is no working hours added")
              : const SizedBox(height: 0),
          Expanded(
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final items =
                      (ref.read(provider).formData["workingHoursList"] as List);
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
    );
  }

  Future<void> _addWorkingHour() async {
    TimeOfDay? time = await showTimePicker(
        helpText: "Select time",
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
        setState(() {
          log("Set state executed");
        });
      } else {
        PopupHelper.instance.showSnackBar(
            message: "This working hour already added to the list",
            error: true);
      }
    }
  }

  Future<void> addBranchProperty() async {}
}

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
      title: const Text("Add working hours"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          workingHour == null
              ? const Text("Select time")
              : Text("Time: $workingHour"),
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
              child: const Text("Choose time")),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, workingHour);
            },
            child: const Text("Add")),
      ],
    );
  }
}
