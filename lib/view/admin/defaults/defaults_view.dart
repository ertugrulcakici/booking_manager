import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultsView extends ConsumerStatefulWidget {
  const DefaultsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DefaultsViewState();
}

class _DefaultsViewState extends ConsumerState<DefaultsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Defaults")),
        body: const Center(
          child: Text("Defaults"),
        ));
  }
}
