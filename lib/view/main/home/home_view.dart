import 'dart:async';

import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/branches/branches_view.dart';
import 'package:bookingmanager/view/admin/expanses/expanses_view.dart';
import 'package:bookingmanager/view/admin/logs/logs_view.dart';
import 'package:bookingmanager/view/admin/statistics/statistics_view.dart';
import 'package:bookingmanager/view/admin/workers/workers_view.dart';
import 'package:bookingmanager/view/main/home/home_notifier.dart';
import 'package:bookingmanager/view/main/session/session_view.dart';
import 'package:bookingmanager/view/user/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final ChangeNotifierProvider<HomeNotifier> provider;
  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => HomeNotifier(this));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getHomeData();
    });
    // for the update the header color of session items
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (ref.watch(provider).isLoading) {
      return const Scaffold(
        body: CustomLoadingWidget(),
      );
    }

    if (ref.watch(provider).isError) {
      return Scaffold(
        body: CustomErrorWidget(
            errorMessage: ref.watch(provider).errorMessage,
            onPressed: ref.read(provider).getHomeData),
      );
    }

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     log(ref.watch(provider).activeBusiness.toString());
      //     log(ref.watch(provider).branches.length.toString());
      //   },
      //   child: const Icon(Icons.add),
      // ),
      drawer: _drawer(),
      appBar: _appBar(),
      body: _content(),
    );
  }

  AppBar _appBar() {
    return AppBar(
        centerTitle: true,
        title: InkWell(
          onTap: _pickDate,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ref.watch(provider).selectedDate.formattedDate),
              const SizedBox(width: 20),
              const Icon(Icons.calendar_today),
            ],
          ),
        ));
  }

  Widget _drawer() {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          bodyLarge: Theme.of(context).textTheme.labelSmall,
          labelLarge: Theme.of(context).textTheme.labelSmall,
        ),
      ),
      child: Drawer(
        child: Column(
          children: _drawerOptions,
        ),
      ),
    );
  }

  List<Widget> get _drawerOptions {
    List<Widget> options = [];
    // header
    options.add(DrawerHeader(
      child: Center(child: Text(AuthService.instance.user!.name)),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     const SizedBox(
      //       height: 50,
      //       width: 50,
      //       child: Placeholder(
      //         fallbackHeight: 50,
      //         fallbackWidth: 50,
      //         strokeWidth: 0.5,
      //       ),
      //     ),
      //     const SizedBox(height: 10),
      //     Text(AuthService.instance.firebaseUser!.displayName.toString())
      //   ],
      // ),
    ));
    // middle options
    List<Widget> middleOptions = [];
    // add expanse
    // middleOptions.add(ListTile(
    //   title: TextButton.icon(
    //       icon: const Icon(Icons.add),
    //       onPressed: () => NavigationService.toPage(const AddExpanseView()),
    //       label: const Text("Add expanse")),
    // ));

    // business settings
    if (ref
        .watch(provider)
        .activeBusiness!
        .adminsUidList
        .contains(AuthService.instance.user!.uid)) {
      middleOptions.add(ExpansionTile(
        leading: const Icon(Icons.business),
        title: const Text("Business management"),
        children: [
          ListTile(
              title: const Text("Expanses"),
              onTap: () => NavigationService.toPage(const ExpansesView()),
              leading: const Icon(Icons.money)),
          ListTile(
              title: const Text("Statistics"),
              onTap: () => NavigationService.toPage(const StatisticsView()),
              leading: const Icon(Icons.bar_chart)),
          ListTile(
              title: const Text("Workers"),
              onTap: () => NavigationService.toPage(const WorkersView()),
              leading: const Icon(Icons.people)),
          ListTile(
              title: const Text("Branches"),
              onTap: () => NavigationService.toPage(const BranchesView()),
              leading: const Icon(Icons.business)),
          ListTile(
              title: const Text("Logs"),
              onTap: () => NavigationService.toPage(const LogsView()),
              leading: const Icon(Icons.history)),
        ],
      ));
    }
    options.add(Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: middleOptions,
      ),
    ));
    // bottom options
    options.add(ListTile(
      title: TextButton.icon(
          icon: const Icon(Icons.person),
          onPressed: () {
            NavigationService.toPage(const ProfileView());
          },
          label: const Text("Profile")),
    ));
    options.add(ListTile(
        title: TextButton.icon(
            icon: const Icon(Icons.exit_to_app),
            onPressed: AuthService.signOut,
            label: const Text("Exit")),
        onTap: AuthService.signOut));
    return options;
  }

  Widget _content() {
    if (ref.watch(provider).branches.isEmpty) {
      return CustomErrorWidget(
          errorMessage: "No branches found",
          onPressed: ref.read(provider).getHomeData);
    }
    return Column(
      children: [
        TabBar(
          controller: ref.watch(provider).tabController,
          labelColor: Colors.black,
          padding: const EdgeInsets.all(8.0),
          labelStyle: const TextStyle(fontSize: 20),
          labelPadding: const EdgeInsets.all(8.0),
          tabs: ref.watch(provider).branches.map((e) => Text(e.name)).toList(),
        ),
        Expanded(
            child: DefaultTabController(
                length: ref.watch(provider).branches.length,
                child: TabBarView(
                  controller: ref.watch(provider).tabController,
                  children: ref
                      .watch(provider)
                      .branches
                      .map((branch) => _branchTab(branch))
                      .toList(),
                )))
      ],
    );
  }

  Widget _branchTab(BranchModel branch) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) => Card(
        child: _sessionItem(
            branchModel: branch, workingHour: branch.workingHoursList[index]),
      ),
      itemCount: branch.workingHoursList.length,
    );
  }

  Widget _sessionItem(
      {required BranchModel branchModel, required String workingHour}) {
    SessionModel? sessionModel;
    ref.watch(provider).sessions[branchModel.uid]?.forEach((element) {
      if (element.time == workingHour) {
        sessionModel = element;
      }
    });

    return InkWell(
      onTap: () {
        NavigationService.toPage(SessionView(
          date: ref.watch(provider).selectedDate.formattedDate,
          time: workingHour,
          sessionModel: sessionModel,
          selectedBranch: branchModel,
          branches: ref.watch(provider).branches,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            sessionModel != null && (sessionModel?.phone ?? "").isNotEmpty
                ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () {
                          if (sessionModel!.phone.isNotEmpty) {
                            launchUrl(
                                Uri.parse("tel://${sessionModel!.phone}"));
                          }
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
            Positioned.fill(
                child: Column(
              children: [
                _sessionItemHeader(workingHour, sessionModel),
                const Divider(height: 1, thickness: 1),
                _sessionItemBody(sessionModel)
              ],
            ))
          ],
        ),
      ),
    );
  }

  Container _sessionItemHeader(String workingHour, SessionModel? sessionModel) {
    DateTime now = DateTime.now();
    DateTime selectedDate = ref.watch(provider).selectedDate;
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        color: sessionModel != null
            ? Colors.green
            : now.isAfter(DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    int.parse(workingHour.split(":")[0]),
                    int.parse(workingHour.split(":")[1])))
                ? Colors.grey
                : Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Center(
        child: Column(
          children: [
            Text(workingHour, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  _sessionItemBody(SessionModel? sessionModel) {
    if (sessionModel == null) {
      return const Expanded(
        child: Center(
          child: Icon(Icons.add, color: Colors.black, size: 50),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                "Name: ${sessionModel.name.isEmpty ? "-" : sessionModel.name}"),
            Text("Person count: ${sessionModel.personCount}"),
            Text(
                "Phone: ${sessionModel.phone.isEmpty ? "-" : sessionModel.phone}"),
            Text(
                "Note: ${sessionModel.note.isEmpty ? "-" : sessionModel.note}"),
            Text(
                "Added by: ${ref.watch(provider).activeBusiness!.users.firstWhere((element) => element.uid == sessionModel.addedBy).name}"),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.watch(provider).selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != ref.watch(provider).selectedDate) {
      ref.read(provider).setSelectedDate(picked);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
