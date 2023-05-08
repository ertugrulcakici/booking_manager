import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/view/auth/forgot_password/forgot_password_view.dart';
import 'package:bookingmanager/view/auth/login/login_notifier.dart';
import 'package:bookingmanager/view/auth/register/register_view.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/logo.jpg',
                  width: 150,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  onSaved: (newValue) {
                    ref.read(provider).formData["email"] = newValue;
                  },
                  initialValue: "ertugrul.cakicii@gmail.com",
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kullanıcı Adı',
                    hintText: 'Kullanıcı adınızı girin',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: "ertuertu27",
                  obscureText: true,
                  onSaved: (newValue) {
                    ref.read(provider).formData["password"] = newValue;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Şifre',
                    hintText: 'Şifrenizi girin',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Giriş Yap'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    NavigationService.toPage(const ForgotPasswordView());
                  },
                  child: const Text('Şifremi Unuttum'),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Hesabınız yok mu?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        // Burada kayıt olma sayfasına yönlendirme yapılabilir.
                        // Şimdilik sadece mesaj verelim.
                        NavigationService.toPage(const RegisterView());
                      },
                      child: const Text('Kayıt Ol'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ref.read(provider).login();
    }
  }
}
