import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpanseView extends ConsumerStatefulWidget {
  const AddExpanseView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddExpanseViewState();
}

class _AddExpanseViewState extends ConsumerState<AddExpanseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Add Expanse"),
    ));
  }
}
