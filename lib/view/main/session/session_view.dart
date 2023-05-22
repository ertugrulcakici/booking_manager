import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:bookingmanager/view/main/session/session_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionView extends ConsumerStatefulWidget {
  final String date;
  final String time;
  final SessionModel? sessionModel;
  final List<BranchModel> branches;
  final BranchModel selectedBranch;
  const SessionView(
      {super.key,
      required this.date,
      required this.time,
      this.sessionModel,
      required this.branches,
      required this.selectedBranch});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SessionViewState();
}

class _SessionViewState extends ConsumerState<SessionView> {
  late final ChangeNotifierProvider<SessionNotifier> provider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController personCountController;
  late final TextEditingController _phoneController;
  late final TextEditingController _extraController;
  late final TextEditingController _discountController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.sessionModel?.name);
    personCountController = TextEditingController(
        text: widget.sessionModel?.personCount.toString() ?? "0");
    _phoneController = TextEditingController(text: widget.sessionModel?.phone);
    _extraController = TextEditingController(
        text: widget.sessionModel?.extra.toString() ?? "0");
    _discountController = TextEditingController(
        text: widget.sessionModel?.discount.toString() ?? "0");
    _noteController = TextEditingController(text: widget.sessionModel?.note);
    provider = ChangeNotifierProvider((ref) => SessionNotifier(
        sessionModel: widget.sessionModel,
        branches: widget.branches,
        selectedBranch: widget.selectedBranch,
        time: widget.time,
        date: widget.date));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.sessionModel != null
              ? LocaleKeys.session_title_edit.tr()
              : LocaleKeys.session_title_add.tr())),
      floatingActionButton: _fab(),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  onSaved: (value) {
                    ref.read(provider).formData["name"] = value;
                  },
                  decoration: InputDecoration(
                      labelText: LocaleKeys.session_name_label.tr(),
                      hintText: LocaleKeys.session_name_hint.tr()),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (personCountController.text.isNotEmpty) {
                            personCountController.text =
                                (int.parse(personCountController.text) + 1)
                                    .toString();
                          }
                        },
                        icon: const Icon(Icons.add)),
                    Expanded(
                        child: TextFormField(
                      onTap: () {
                        if (personCountController.text == "0") {
                          personCountController.text = "";
                        }
                      },
                      validator: (value) {
                        String newValue = value?.trim() ?? "";
                        if (newValue.isNotEmpty) {
                          try {
                            int.parse(newValue);
                          } catch (e) {
                            return LocaleKeys.session_person_count_error_message
                                .tr();
                          }
                        } else {
                          return LocaleKeys.session_person_count_error_message
                              .tr();
                        }
                        return null;
                      },
                      controller: personCountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSaved: (value) {
                        ref.read(provider).formData["personCount"] =
                            int.parse(value!);
                      },
                      decoration: InputDecoration(
                          labelText: LocaleKeys.session_person_count_label.tr(),
                          hintText: LocaleKeys.session_person_count_hint.tr()),
                    )),
                    IconButton(
                        onPressed: () {
                          if (personCountController.text.isNotEmpty) {
                            personCountController.text =
                                (int.parse(personCountController.text) - 1)
                                    .toString();
                          }
                        },
                        icon: const Icon(Icons.remove)),
                  ],
                ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    ref.read(provider).formData["phone"] = value;
                  },
                  decoration: InputDecoration(
                      labelText: LocaleKeys.session_phone_label.tr(),
                      hintText: LocaleKeys.session_phone_hint.tr()),
                ),
                TextFormField(
                  controller: _extraController,
                  validator: (value) {
                    String newValue = value?.replaceAll(",", ".").trim() ?? "";
                    if (newValue.isNotEmpty) {
                      try {
                        double.parse(newValue);
                      } catch (e) {
                        return LocaleKeys.session_extra_error_message.tr();
                      }
                    }
                    return null;
                  },
                  onTap: () {
                    if (_extraController.text == "0") {
                      _extraController.text = "";
                    }
                  },
                  onSaved: (value) {
                    if (value == null || value.isEmpty) {
                      value = "0";
                    }
                    ref.read(provider).formData["extra"] = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: LocaleKeys.session_extra_label.tr(),
                      hintText: LocaleKeys.session_extra_hint.tr()),
                ),
                TextFormField(
                  validator: (value) {
                    String newValue = value?.replaceAll(",", ".").trim() ?? "";
                    if (newValue.isNotEmpty) {
                      try {
                        double.parse(newValue);
                      } catch (e) {
                        return LocaleKeys.session_discount_error_message.tr();
                      }
                    }
                    return null;
                  },
                  controller: _discountController,
                  onTap: () {
                    if (_discountController.text == "0") {
                      _discountController.text = "";
                    }
                  },
                  onSaved: (value) {
                    if (value == null || value.isEmpty) {
                      value = "0";
                    }
                    ref.read(provider).formData["discount"] =
                        double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: LocaleKeys.session_discount_label.tr(),
                      hintText: LocaleKeys.session_discount_hint.tr()),
                ),
                TextFormField(
                  controller: _noteController,
                  onSaved: (value) {
                    ref.read(provider).formData["note"] = value;
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: LocaleKeys.session_note_label.tr(),
                      hintText: LocaleKeys.session_note_hint.tr()),
                ),
                DropdownButtonFormField<BranchModel?>(
                  value: widget.selectedBranch,
                  onChanged: (value) {
                    ref.read(provider).selectedBranch = value!;
                  },
                  items: widget.branches
                      .map((branchModel) => DropdownMenuItem(
                            value: branchModel,
                            child: Text(branchModel.name),
                          ))
                      .toList(),
                ),
                DropdownButtonFormField<String>(
                    value: ref.watch(provider).formData["time"],
                    items: ref
                        .watch(provider)
                        .selectedBranch
                        .workingHoursList
                        .map((time) =>
                            DropdownMenuItem(value: time, child: Text(time)))
                        .toList(),
                    onChanged: (value) {
                      ref.read(provider).formData["time"] = value;
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(ref.watch(provider).formData["date"]!),
                    IconButton(
                        onPressed: () async {
                          DateTime? selectedTime = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              initialDate: widget.date.toDateTime);
                          if (selectedTime != null) {
                            setState(() {
                              ref.read(provider).formData["date"] =
                                  selectedTime.formattedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today))
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget _fab() {
    List<Widget> fabWidgets = [];
    fabWidgets.add(FloatingActionButton.extended(
        heroTag: "save",
        key: const Key("save"),
        onPressed: () {
          if (widget.sessionModel != null) {
            PopupHelper.instance.showOkCancelDialog(
                title: LocaleKeys.session_update_session_popup_title.tr(),
                content: LocaleKeys.session_update_session_popup_content.tr(),
                onOk: _save);
          } else {
            _save();
          }
        },
        label: Text(LocaleKeys.save.tr()),
        icon: const Icon(Icons.check)));
    if (widget.sessionModel != null) {
      fabWidgets.add(const SizedBox(height: 10));
      fabWidgets.add(FloatingActionButton.extended(
          heroTag: "delete",
          key: const Key("delete"),
          onPressed: ref.read(provider).deleteSession,
          label: Text(LocaleKeys.delete.tr()),
          icon: const Icon(Icons.delete)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: fabWidgets,
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(provider).save();
    }
  }
}
