import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/extensions/list_extensions.dart';
import 'package:bookingmanager/product/enums/session_history_type_enum.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/models/business_model.dart';
import 'package:bookingmanager/product/models/session_history_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/view/admin/session_history/session_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionHistoryView extends ConsumerStatefulWidget {
  final BusinessModel activeBusiness;
  final List<BranchModel> branches;
  const SessionHistoryView(
      {super.key, required this.activeBusiness, required this.branches});

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
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(ref.watch(provider).selectedDate.formattedDate),
          const SizedBox(width: 10),
          IconButton(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today),
          )
        ]),
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

    return _content();
  }

  Widget _content() {
    if (ref.watch(provider).sessionHistories.isEmpty) {
      return const Center(child: Text("No session history on that day"));
    }
    return ListView.builder(
      itemCount: ref.watch(provider).sessionHistories.length,
      itemBuilder: (context, index) {
        SessionHistoryModel sessionHistory =
            ref.watch(provider).sessionHistories.reversed.toList()[index];
        return _sessionHistoryCard(sessionHistory);
      },
    );
  }

  Card _sessionHistoryCard(SessionHistoryModel sessionHistory) {
    return Card(
      child: ListTile(
        title: Text(sessionHistory.historyType == SessionHistoryType.deleted
            ? "Session has been deleted"
            : "Session has been updated from left to right"),
        subtitle: Column(children: [
          const Divider(),
          Text(
              "Time: ${DateTime.fromMillisecondsSinceEpoch(sessionHistory.timestamp).formattedDateTime}"),
          Text(
              "By: ${widget.activeBusiness.users.firstWhere((element) => element.uid == sessionHistory.by).name}"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [sessionHistory.originalSession]
                  .addConditionally(
                      condition: () =>
                          sessionHistory.historyType ==
                          SessionHistoryType.updated,
                      value: () => sessionHistory.updatedSession)
                  .map((e) => _sessionInfoCard(e))
                  .toList()
                  .cast<Widget>(),
            ),
          )
        ]),
      ),
    );
  }

  _sessionInfoCard(SessionModel sessionModel) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Text(
              "Branch: ${widget.branches.firstWhere((element) => element.uid == sessionModel.branchUid).name}"),
          Text("Date: ${sessionModel.timestamp.toDateTime().formattedDate}"),
          Text("Time: ${sessionModel.timestamp.toDateTime().formattedTime}"),
          Text("Name: ${sessionModel.name}"),
          Text("Phone: ${sessionModel.phone}"),
          Text("Total: ${sessionModel.total}"),
          Text("Extra: ${sessionModel.extra}"),
          Text("Discount: ${sessionModel.discount}"),
          Text("Person count: ${sessionModel.personCount}"),
          Text("Note: ${sessionModel.note}"),
          Text(
              "Added by: ${widget.activeBusiness.users.firstWhere((element) => element.uid == sessionModel.addedBy).name}"),
        ],
      ),
    );
  }

  _pickDate() {
    showDatePicker(
            context: context,
            initialDate: ref.watch(provider).selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2025))
        .then((value) {
      if (value != null) {
        ref.watch(provider).selectedDate = value;
        ref.read(provider).getLogs();
      }
    });
  }
}
