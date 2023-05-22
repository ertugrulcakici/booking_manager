import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/view/settings/settings_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final provider = ChangeNotifierProvider((ref) => SettingsNotifier());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settings_title.tr())),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      children: [
        _language(),
        _theme(),
      ],
    );
  }

  Widget _language() {
    return ListTile(
      title: Text(LocaleKeys.settings_language.tr()),
      trailing: DropdownButton(
        value: ref.watch(provider).language,
        onChanged: (newValue) {
          ref.read(provider).language = newValue.toString();
        },
        items: const [
          DropdownMenuItem(
            value: "en",
            child: Text("English"),
          ),
          DropdownMenuItem(
            value: "tr",
            child: Text("Türkçe"),
          ),
        ],
      ),
    );
  }

  Widget _theme() {
    // TODO: implement _theme
    return Container();
  }
}
