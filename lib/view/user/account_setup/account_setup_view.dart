import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/view/admin/create_business/create_business_view.dart';
import 'package:bookingmanager/view/user/account_setup/account_setup_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
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
      drawer: _drawer(),
      floatingActionButton: _fab(),
      appBar: AppBar(title: Text(LocaleKeys.account_setup_title.tr())),
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
              title: Text(LocaleKeys.account_setup_business_owner.tr()),
              value: false,
              groupValue: ref.watch(provider).isWorker,
              onChanged: (value) {
                ref.read(provider).isWorker = false;
              },
            ),
            RadioListTile<bool>(
              title: Text(LocaleKeys.account_setup_worker.tr()),
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
                    decoration: InputDecoration(
                      labelText:
                          LocaleKeys.account_setup_invitation_code_label.tr(),
                      hintText:
                          LocaleKeys.account_setup_invitation_code_hint.tr(),
                    ))),
            Visibility(
                visible: !ref.watch(provider).isWorker,
                child: Text(LocaleKeys.account_setup_next_step_hint.tr())),
          ],
        )),
      ),
    );
  }

  Drawer _drawer() {
    return Drawer(
      child: Center(
        child: TextButton.icon(
            onPressed: AuthService.signOut,
            icon: const Icon(Icons.logout),
            label: Text(LocaleKeys.account_setup_logout_button.tr())),
      ),
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      heroTag: "continue",
      onPressed: () {
        if (ref.watch(provider).isWorker) {
          ref.read(provider).joinViaCode(_controller.text.trim()).then((value) {
            _controller.text = "";
          });
          _controller.text = "";
        } else {
          NavigationService.toPage(const CreateBusinessView());
        }
      },
      child: const Icon(Icons.arrow_forward_ios),
    );
  }
}
