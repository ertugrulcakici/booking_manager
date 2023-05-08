import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/view/admin/create_business/create_business_view.dart';
import 'package:bookingmanager/view/user/account_setup/account_setup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSetupView extends ConsumerStatefulWidget {
  const AccountSetupView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSetupViewState();
}

class _AccountSetupViewState extends ConsumerState<AccountSetupView> {
  ChangeNotifierProvider<AccountSetupNotifier> provider =
      ChangeNotifierProvider((ref) => AccountSetupNotifier());

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: TextButton.icon(
              onPressed: AuthService.signOut,
              icon: const Icon(Icons.logout),
              label: const Text("Logout")),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "continue",
        onPressed: () {
          if (ref.watch(provider).isWorker) {
            ref
                .read(provider)
                .joinViaCode(_controller.text.trim())
                .then((value) {
              _controller.text = "";
            });
            _controller.text = "";
          } else {
            NavigationService.toPage(const CreateBusinessView());
          }
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
      appBar: AppBar(title: const Text("Hesap Oluştur")),
      body: Center(
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            RadioListTile<bool>(
              title: const Text('İşletme sahibi'),
              value: false,
              groupValue: ref.watch(provider).isWorker,
              onChanged: (value) {
                ref.read(provider).isWorker = false;
              },
            ),
            RadioListTile<bool>(
              title: const Text('Çalışan'),
              value: true,
              groupValue: ref.watch(provider).isWorker,
              onChanged: (value) {
                ref.read(provider).isWorker = true;
              },
            ),
            const SizedBox(height: 32),
            Visibility(
                visible: ref.watch(provider).isWorker,
                child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Invitation code",
                    ))),
            Visibility(
                visible: !ref.watch(provider).isWorker,
                child:
                    const Text("Bir sonraki adımda işletme oluşturacaksınız")),
          ],
        )),
      ),
    );
  }
}
