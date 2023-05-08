import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsView extends ConsumerStatefulWidget {
  const StatisticsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends ConsumerState<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
    );
  }
}
