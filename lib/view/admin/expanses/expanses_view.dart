import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/expanse_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/expanse_categories/expanse_categories_view.dart';
import 'package:bookingmanager/view/admin/expanses/expanses_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpansesView extends ConsumerStatefulWidget {
  const ExpansesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpansesViewState();
}

class _ExpansesViewState extends ConsumerState<ExpansesView> {
  final provider = ChangeNotifierProvider((ref) => ExpansesNotifier());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(provider).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigationService.toPage(ExpanseCategoriesView(
              categories: ref.watch(provider).categories));
        },
        label: const Text("Categories"),
        icon: const Icon(Icons.category),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ref.watch(provider).selectedDate.formattedDate),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: ref.watch(provider).selectedDate,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101));
                if (picked != null &&
                    picked != ref.watch(provider).selectedDate) {
                  ref.read(provider).selectedDate = picked;
                }
              },
              icon: const Icon(Icons.calendar_today),
            )
          ],
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return const CustomLoadingWidget();
    }

    if (ref.watch(provider).isError) {
      return CustomErrorWidget(
          errorMessage: ref.watch(provider).errorMessage,
          onPressed: ref.read(provider).getData);
    }

    return _content();
  }

  Widget _content() {
    return ListView.separated(
        itemBuilder: (context, index) {
          final expanse = ref.watch(provider).expanses[index];
          return _expanseItem(expanse);
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: ref.watch(provider).expanses.length);
  }

  Widget _expanseItem(ExpanseModel expanse) {
    return Slidable(
      startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ]),
      child: ListTile(
        title: Text(expanse.categoryUid),
        subtitle: Text(expanse.note),
        trailing: Text(expanse.amount.toString()),
      ),
    );
  }
}
