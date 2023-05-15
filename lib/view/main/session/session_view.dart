import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:bookingmanager/view/main/session/session_notifier.dart';
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
      appBar: AppBar(title: const Text("Session")),
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
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
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
                            return "Please enter a valid number";
                          }
                        } else {
                          return "Please enter a valid number";
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
                      decoration: const InputDecoration(
                        labelText: "Person count",
                      ),
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
                  decoration: const InputDecoration(
                    labelText: "Phone number",
                  ),
                ),
                TextFormField(
                  controller: _extraController,
                  validator: (value) {
                    String newValue = value?.replaceAll(",", ".").trim() ?? "";
                    if (newValue.isNotEmpty) {
                      try {
                        double.parse(newValue);
                      } catch (e) {
                        return "Please enter a valid number";
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
                  decoration: const InputDecoration(
                    labelText: "Extra",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    String newValue = value?.replaceAll(",", ".").trim() ?? "";
                    if (newValue.isNotEmpty) {
                      try {
                        double.parse(newValue);
                      } catch (e) {
                        return "Please enter a valid number";
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
                  decoration: const InputDecoration(
                    labelText: "Discount",
                  ),
                ),
                TextFormField(
                  controller: _noteController,
                  onSaved: (value) {
                    ref.read(provider).formData["note"] = value;
                  },
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Note",
                  ),
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
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text(
                        "You are about to update this session. Are you sure?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            NavigationService.back();
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            _save();
                          },
                          child: const Text("Yes")),
                    ],
                  );
                });
          } else {
            _save();
          }
        },
        label: const Text("Save"),
        icon: const Icon(Icons.check)));
    if (widget.sessionModel != null) {
      fabWidgets.add(const SizedBox(height: 10));
      fabWidgets.add(FloatingActionButton.extended(
          heroTag: "delete",
          key: const Key("delete"),
          onPressed: ref.read(provider).deleteSession,
          label: const Text("Delete"),
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
    } else {
      PopupHelper.instance
          .showSnackBar(message: "Please fill all fields", error: true);
    }
  }
}
