import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/view/admin/expanse_categories/expanse_categories_view.dart';
import 'package:bookingmanager/view/admin/expanses/expanses_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpansesView extends ConsumerStatefulWidget {
  const ExpansesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpansesViewState();
}

class _ExpansesViewState extends ConsumerState<ExpansesView> {
  final provider = ChangeNotifierProvider((ref) => ExpansesNotifier());

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
          children: [
            Text(
                "Expanses on ${ref.watch(provider).selectedDate.formattedDate}"),
            const Spacer(),
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
    );
  }
}
