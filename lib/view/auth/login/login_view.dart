import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/view/auth/forgot_password/forgot_password_view.dart';
import 'package:bookingmanager/view/auth/login/login_notifier.dart';
import 'package:bookingmanager/view/auth/register/register_view.dart';
import 'package:bookingmanager/view/settings/settings_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late final ChangeNotifierProvider<LoginNotifier> provider;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => LoginNotifier());
    _formKey = GlobalKey<FormState>();
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
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logo(),
            _fields(),
            _loginButton(),
            _forgotPasswordButton(),
            const Spacer(),
            _registerButton(),
            _settings(),
          ],
        ),
      ),
    );
  }

  Container _logo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      child: Image.asset(
        "assets/images/logo.png",
        width: 150,
      ),
    );
  }

  Widget _fields() {
    return Column(children: [
      TextFormField(
        onSaved: (newValue) {
          ref.read(provider).formData["email"] = newValue;
        },
        initialValue: kDebugMode ? "ertugrul.cakicii@gmail.com" : null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: LocaleKeys.login_username_label.tr(),
          hintText: LocaleKeys.login_username_hint.tr(),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        initialValue: kDebugMode ? "googleAccount1" : null,
        obscureText: true,
        onSaved: (newValue) {
          ref.read(provider).formData["password"] = newValue;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: LocaleKeys.login_password_label.tr(),
          hintText: LocaleKeys.login_password_hint.tr(),
        ),
      ),
    ]);
  }

  Widget _loginButton() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: _login,
        child: Text(LocaleKeys.login_login_button.tr()),
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: () {
          NavigationService.toPage(const ForgotPasswordView());
        },
        child: Text(LocaleKeys.login_forgot_password_button.tr()),
      ),
    );
  }

  Widget _registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LocaleKeys.login_no_account_message.tr()),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () {
            // Burada kayıt olma sayfasına yönlendirme yapılabilir.
            // Şimdilik sadece mesaj verelim.
            NavigationService.toPage(const RegisterView());
          },
          child: Text(LocaleKeys.login_register_button.tr()),
        ),
      ],
    );
  }

  Align _settings() {
    return Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: () {
            NavigationService.toPage(const SettingsView());
          },
          icon: const Icon(Icons.settings),
        ));
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ref.read(provider).login();
    }
  }
}
