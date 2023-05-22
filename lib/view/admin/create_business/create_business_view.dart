import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/view/admin/create_business/create_business_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBusinessView extends ConsumerStatefulWidget {
  const CreateBusinessView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateBusinessViewState();
}

class _CreateBusinessViewState extends ConsumerState<CreateBusinessView> {
  ChangeNotifierProvider<CreateBusinessNotifier> provider =
      ChangeNotifierProvider((ref) => CreateBusinessNotifier());
  final TextEditingController _businessNameController = TextEditingController(
      text: kDebugMode ? "27. Region Horror House" : null);

  @override
  void dispose() {
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.create_business_title.tr())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(provider).save(businessName: _businessNameController.text);
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
      body: Center(
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
            const SizedBox(height: 24.0),
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: LocaleKeys.create_business_business_name_label.tr(),
                hintText: LocaleKeys.create_business_business_name_hint.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
