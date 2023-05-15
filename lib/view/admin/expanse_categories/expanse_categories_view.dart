import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/expanse_category_model.dart';
import 'package:bookingmanager/product/widgets/error_widget.dart';
import 'package:bookingmanager/view/admin/expanse_categories/category_line_widget.dart';
import 'package:bookingmanager/view/admin/expanse_categories/expanse_categories_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpanseCategoriesView extends ConsumerStatefulWidget {
  final List<ExpanseCategoryModel> categories;
  const ExpanseCategoriesView({super.key, required this.categories});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpanseCategoriesViewState();
}

class _ExpanseCategoriesViewState extends ConsumerState<ExpanseCategoriesView> {
  late final ChangeNotifierProvider<ExpanseCategoriesNotifier> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider(
        (ref) => ExpanseCategoriesNotifier(categories: widget.categories));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      appBar: AppBar(
        title: const Text("Expanse categories"),
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
          onPressed: () {
            // TODO: this should be a method in the notifier or something else
            NavigationService.back();
          });
    }

    return _content();
  }

  Widget _content() {
    return ListView.builder(
      itemCount: ref.watch(provider).categories.length,
      itemBuilder: (context, index) {
        final category = ref.watch(provider).categories[index];
        return CategoryLineWidget(
          data: category.name,
          onSave: (newValue) async {
            return await ref
                .read(provider)
                .editCategoryName(category, newValue);
          },
          onDelete: () {
            ref.read(provider).deleteCategory(category);
          },
        );
      },
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton.extended(
      onPressed: _addCategoryPopup,
      label: const Text("Add category"),
      icon: const Icon(Icons.add),
    );
  }

  Future<void> _addCategoryPopup() async {
    showDialog(
        context: context,
        builder: (context) {
          return AddPopup(onSubmit: ref.read(provider).addCategory);
        });
  }
}

// TODO: this should be in a separate file
class AddPopup extends StatefulWidget {
  final Function(String value) onSubmit;
  const AddPopup({super.key, required this.onSubmit});

  @override
  State<AddPopup> createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add category"),
      content: TextField(
        controller: _controller,
        onEditingComplete: () {
          widget.onSubmit(_controller.text);
        },
        decoration: const InputDecoration(hintText: "Category name"),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onSubmit(_controller.text);
            },
            child: const Text("Add"))
      ],
    );
  }
}
