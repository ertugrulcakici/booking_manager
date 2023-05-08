import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'E-posta adresiniz',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Burada mail gönderme işlemi yapılabilir.
                // Şimdilik sadece mesaj verelim.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Şifre sıfırlama maili gönderildi.'),
                  ),
                );
              },
              child: const Text('Şifremi Sıfırla'),
            ),
          ],
        ),
      ),
    );
  }
}
