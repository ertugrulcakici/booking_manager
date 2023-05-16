import 'package:flutter/material.dart';

class CategoryLineWidget extends StatefulWidget {
  final Future<bool> Function(String) onSave;
  final Function() onDelete;
  final String data;
  const CategoryLineWidget(
      {super.key,
      required this.onSave,
      required this.data,
      required this.onDelete});

  @override
  State<CategoryLineWidget> createState() => _CategoryLineWidgetState();
}

class _CategoryLineWidgetState extends State<CategoryLineWidget> {
  final FocusNode focusNode = FocusNode();
  late final TextEditingController controller;
  bool focused = false;

  @override
  void initState() {
    controller = TextEditingController(text: widget.data);
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        if (widget.data != controller.text) {
          widget.onSave(controller.text).then((value) {
            if (!value) {
              controller.text = widget.data;
            }
          });
        }
        _unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: focused
            ? TextField(
                focusNode: focusNode,
                controller: controller,
                onEditingComplete: () {
                  _unfocus();
                },
              )
            : InkWell(onTap: _focus, child: Text(controller.text)),
        trailing: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              focused
                  ? IconButton(
                      onPressed: () {
                        _unfocus();
                        if (widget.data != controller.text) {
                          widget.onSave(controller.text).then((value) {
                            if (!value) {
                              controller.text = widget.data;
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.check))
                  : IconButton(
                      onPressed: () {
                        _focus();
                      },
                      icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: widget.onDelete, icon: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }

  _focus() {
    setState(() {
      focused = true;
    });
    focusNode.requestFocus();
  }

  _unfocus() {
    setState(() {
      focused = false;
    });
    focusNode.unfocus();
  }
}
