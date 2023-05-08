import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogsView extends ConsumerStatefulWidget {
  const LogsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogsViewState();
}

class _LogsViewState extends ConsumerState<LogsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
      ),
    );
  }
}
