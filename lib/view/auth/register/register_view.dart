import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/view/auth/register/register_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final TextEditingController _emailController =
      TextEditingController(text: kDebugMode ? "ertu1ertu@hotmail.com" : null);
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? "googleAccount1" : null);

  final TextEditingController _nameController =
      TextEditingController(text: kDebugMode ? "Google Account" : null);

  bool _isObscure = true;

  late final GlobalKey<FormState> _formKey;

  late final ChangeNotifierProvider<RegisterNotifier> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => RegisterNotifier());
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.register_title.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  onSaved: (newValue) {
                    ref.read(provider).formData["email"] = newValue;
                  },
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.register_email_label.tr(),
                    hintText: LocaleKeys.register_email_hint.tr(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onSaved: (newValue) {
                    ref.read(provider).formData["password"] = newValue;
                  },
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      labelText: LocaleKeys.register_password_label.tr(),
                      hintText: LocaleKeys.register_password_hint.tr(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye))),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  onSaved: (newValue) {
                    ref.read(provider).formData["name"] = newValue;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleKeys.register_name_label.tr(),
                    hintText: LocaleKeys.register_name_hint.tr(),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ref.read(provider).register();
                    }
                  },
                  child: Text(LocaleKeys.register_register_button.tr()),
                ),
              ],
            )),
      ),
    );
  }
}
