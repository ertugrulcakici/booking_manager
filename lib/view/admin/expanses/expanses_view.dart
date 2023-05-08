import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpansesView extends ConsumerStatefulWidget {
  const ExpansesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpansesViewState();
}

class _ExpansesViewState extends ConsumerState<ExpansesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expanses"),
      ),
    );
  }
}
