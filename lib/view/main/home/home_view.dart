import 'dart:async';

import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/branches/branches_view.dart';
import 'package:bookingmanager/view/admin/expanses/expanses_view.dart';
import 'package:bookingmanager/view/admin/session_history/session_history_view.dart';
import 'package:bookingmanager/view/admin/workers/workers_view.dart';
import 'package:bookingmanager/view/main/add_expanse/add_expanse_view.dart';
import 'package:bookingmanager/view/main/home/home_notifier.dart';
import 'package:bookingmanager/view/main/session/session_view.dart';
import 'package:bookingmanager/view/settings/settings_view.dart';
import 'package:easy_localization/easy_localization.dart';
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
    ));
    // middle options
    List<Widget> middleOptions = [];
    middleOptions.add(
      ListTile(
        title: TextButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              NavigationService.toPage(const AddExpanseView());
            },
            label: Text(LocaleKeys.home_add_expanse.tr())),
      ),
    );

    // business settings
    if (ref
        .watch(provider)
        .activeBusiness!
        .adminsUidList
        .contains(AuthService.instance.user!.uid)) {
      middleOptions.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          leading: const Icon(Icons.business),
          title: Text(LocaleKeys.home_business_management.tr()),
          children: [
            ListTile(
                title: Text(LocaleKeys.home_expanses.tr()),
                onTap: () => NavigationService.toPage(const ExpansesView()),
                leading: const Icon(Icons.money)),
            // ListTile(
            //     title: const Text("Statistics"),
            //     onTap: () => NavigationService.toPage(const StatisticsView()),
            //     leading: const Icon(Icons.bar_chart)),
            ListTile(
                title: Text(LocaleKeys.home_workers.tr()),
                onTap: () => NavigationService.toPage(const WorkersView()),
                leading: const Icon(Icons.people)),
            ListTile(
                title: Text(LocaleKeys.home_branches.tr()),
                onTap: () => NavigationService.toPage(const BranchesView()),
                leading: const Icon(Icons.business)),
            ListTile(
                title: Text(LocaleKeys.home_session_history.tr()),
                onTap: () => NavigationService.toPage(SessionHistoryView(
                    activeBusiness: ref.watch(provider).activeBusiness!,
                    branches: ref.watch(provider).activeBusiness!.branches)),
                leading: const Icon(Icons.history)),
          ],
        ),
      ));
    }
    options.add(Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: middleOptions,
      ),
    ));
    // bottom options
    // options.add(ListTile(
    //   title: TextButton.icon(
    //       icon: const Icon(Icons.person),
    //       onPressed: () {
    //         NavigationService.toPage(const ProfileView());
    //       },
    //       label: Text(LocaleKeys.home_profile.tr())),
    // ));
    options.add(
      ListTile(
        title: TextButton.icon(
            icon: const Icon(Icons.settings),
            onPressed: () {
              NavigationService.toPage(const SettingsView());
            },
            label: Text(LocaleKeys.home_settings.tr())),
        onTap: AuthService.signOut,
      ),
    );
    options.add(ListTile(
        title: TextButton.icon(
            icon: const Icon(Icons.exit_to_app),
            onPressed: AuthService.signOut,
            label: Text(LocaleKeys.home_exit.tr())),
        onTap: AuthService.signOut));
    return options;
  }

  Widget _content() {
    if (ref.watch(provider).activeBusiness!.branches.isEmpty) {
      return CustomErrorWidget(
          errorMessage: LocaleKeys.home_no_branches_found.tr(),
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
          tabs: ref
              .watch(provider)
              .activeBusiness!
              .branches
              .map((e) => Text(e.name))
              .toList(),
        ),
        Expanded(
            child: DefaultTabController(
                length: ref.watch(provider).activeBusiness!.branches.length,
                child: TabBarView(
                  controller: ref.watch(provider).tabController,
                  children: ref
                      .watch(provider)
                      .activeBusiness!
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
      itemBuilder: (context, index) => _sessionItem(
          branchModel: branch, workingHour: branch.workingHoursList[index]),
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
          branches: ref.watch(provider).activeBusiness!.branches,
        ));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
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
            Text(LocaleKeys.home_name_label.tr(
                args: [sessionModel.name.isEmpty ? "-" : sessionModel.name])),
            Text(LocaleKeys.home_person_count_label
                .tr(args: [sessionModel.personCount.toString()])),
            Text(LocaleKeys.home_phone_label.tr(
                args: [sessionModel.phone.isEmpty ? "-" : sessionModel.phone])),
            Text(LocaleKeys.home_note_label.tr(
                args: [sessionModel.note.isEmpty ? "-" : sessionModel.note])),
            Text(LocaleKeys.home_added_by_label.tr(args: [
              ref
                  .watch(provider)
                  .activeBusiness!
                  .users
                  .firstWhere((element) => element.uid == sessionModel.addedBy)
                  .name
            ])),
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
