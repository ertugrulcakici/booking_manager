import 'package:bookingmanager/view/auth/register/register_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final TextEditingController _emailController =
      TextEditingController(text: "ertugrul.cakicii@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "ertuertu27");

  final TextEditingController _nameController =
      TextEditingController(text: "Ertuğrul Çakıcı");

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
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
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
                  decoration: const InputDecoration(
                    labelText: 'E-Posta Adresi',
                    hintText: 'ornek@ornek.com',
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
                      labelText: 'Şifre',
                      hintText: '******',
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
                  decoration: const InputDecoration(
                    labelText: 'İsim',
                    hintText: 'İsim',
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
                  child: const Text('Kayıt Ol'),
                ),
              ],
            )),
      ),
    );
  }
}
