import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/view/main/add_expanse/add_expanse_notifier.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpanseView extends ConsumerStatefulWidget {
  const AddExpanseView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddExpanseViewState();
}

class _AddExpanseViewState extends ConsumerState<AddExpanseView> {
  final provider = ChangeNotifierProvider((ref) => AddExpanseNotifier());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(provider).getExpanseCategories();
    });
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
      appBar: AppBar(title: Text(LocaleKeys.add_expanse_title.tr())),
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ref.watch(provider).isError) {
      return CustomErrorWidget(
          errorMessage: ref.watch(provider).errorMessage,
          onPressed: ref.watch(provider).categories.isEmpty
              ? ref.read(provider).getExpanseCategories
              : ref.read(provider).addExpanse);
    }

    return _content();
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_amount(), _category(), _note()],
        ),
      ),
    );
  }

  Widget _amount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: LocaleKeys.add_expanse_amount_label.tr(),
        hintText: LocaleKeys.add_expanse_amount_hint.tr(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.add_expanse_amount_error_message.tr();
        }
        try {
          double.parse(value);
        } catch (e) {
          return LocaleKeys.add_expanse_amount_error_message.tr();
        }
        return null;
      },
      onSaved: (newValue) {
        ref.read(provider).formData["amount"] = double.parse(newValue!);
      },
    );
  }

  Widget _category() {
    return DropDownTextField(
      controller: SingleValueDropDownController(
          data: DropDownValueModel(
        name: ref.watch(provider).categories.first.name,
        value: ref.watch(provider).categories.first.uid,
      )),
      dropDownList: ref
          .watch(provider)
          .categories
          .map((expanseCategoryModel) => DropDownValueModel(
              name: expanseCategoryModel.name, value: expanseCategoryModel.uid))
          .toList(),
      enableSearch: true,
      textFieldDecoration: InputDecoration(
        labelText: LocaleKeys.add_expanse_category_label.tr(),
      ),
      clearOption: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.add_expanse_category_error_message.tr();
        }
        return null;
      },
      onChanged: (newValue) {
        ref.read(provider).formData["categoryUid"] =
            (newValue as DropDownValueModel).value;
      },
    );
  }

  Widget _note() {
    return TextFormField(
      maxLines: 3,
      decoration: InputDecoration(
        labelText: LocaleKeys.add_expanse_note_label.tr(),
        hintText: LocaleKeys.add_expanse_note_hint.tr(),
      ),
      onSaved: (newValue) {
        ref.read(provider).formData["note"] = newValue;
      },
    );
  }

  Widget _fab() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          ref.read(provider).addExpanse();
        }
      },
      label: Text(LocaleKeys.add.tr()),
      icon: const Icon(Icons.add),
    );
  }
}
