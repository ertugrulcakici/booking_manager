import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/expanse_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/product/widgets/loading_widget.dart';
import 'package:bookingmanager/view/admin/expanse_categories/expanse_categories_view.dart';
import 'package:bookingmanager/view/admin/expanses/expanses_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
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
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(provider).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
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
    if (ref.watch(provider).expanses.isEmpty) {
      return Center(child: Text(LocaleKeys.expanses_no_expanses.tr()));
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          final expanse = ref.watch(provider).expanses[index];
          return _expanseItem(expanse);
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: ref.watch(provider).expanses.length);
  }

  Widget _expanseItem(ExpanseModel expanse) {
    return Card(
      child: ListTile(
        title: Text(LocaleKeys.expanses_expanse_category.tr(args: [
          ref
              .watch(provider)
              .categories
              .firstWhere((element) => element.uid == expanse.categoryUid)
              .name
        ])),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.expanses_expanse_amount
                .tr(args: [expanse.amount.toStringAsFixed(2)])),
            Text(LocaleKeys.expanses_expanse_note.tr(args: [expanse.note])),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            PopupHelper.instance.showOkCancelDialog(
                title: LocaleKeys.expanses_delete_expanse_title.tr(),
                content: LocaleKeys.expanses_delete_expanse_content.tr(),
                onOk: () {
                  ref.read(provider).deleteExpanse(expanse);
                });
          },
        ),
      ),
    );
  }

  _fab() {
    return FloatingActionButton.extended(
      onPressed: () {
        NavigationService.toPage(
            ExpanseCategoriesView(categories: ref.watch(provider).categories));
      },
      label: Text(LocaleKeys.expanses_fab_text.tr()),
      icon: const Icon(Icons.category),
    );
  }
}
