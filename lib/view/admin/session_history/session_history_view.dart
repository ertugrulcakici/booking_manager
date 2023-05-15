import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/view/admin/session_history/session_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionHistoryView extends ConsumerStatefulWidget {
  const SessionHistoryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SessionHistoryViewState();
}

class _SessionHistoryViewState extends ConsumerState<SessionHistoryView> {
  final provider = ChangeNotifierProvider((ref) => SessionLogsNotifier());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(provider).getLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session History"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ref.watch(provider).isError) {
      return CustomErrorWidget(
          errorMessage: ref.watch(provider).errorMessage,
          onPressed: ref.read(provider).getLogs);
    }

    return Center(
      child: Column(
        children: const [],
      ),
    );
  }
}
