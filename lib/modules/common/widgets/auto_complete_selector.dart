import 'package:flutter/material.dart';

class AutocompleteSelector<T extends Object> extends StatefulWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemLabel; // how to display object
  final void Function(T) onSelected;
  final void Function(String)? onNewItem; // when typed text is new
  final T? initialValue;

  const AutocompleteSelector({
    Key? key,
    required this.label,
    required this.items,
    this.selectedItem,
    required this.itemLabel,
    required this.onSelected,
    this.onNewItem,
    this.initialValue,
  }) : super(key: key);

  @override
  State<AutocompleteSelector<T>> createState() =>
      _AutocompleteSelectorState<T>();
}

class _AutocompleteSelectorState<T extends Object>
    extends State<AutocompleteSelector<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedItem != null
          ? widget.itemLabel(widget.selectedItem!)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant AutocompleteSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update text if selection changed — not every rebuild
    // if (oldWidget.selectedItem != widget.selectedItem &&
    //     widget.selectedItem != null) {
    //   _controller.text = widget.itemLabel(widget.selectedItem!);
    // }

    // Determine the new text based on selectedItem
    final newText = widget.selectedItem != null
        ? widget.itemLabel(widget.selectedItem!)
        : '';

    // Update controller text if it's different from current
    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (widget.items.isEmpty) return Iterable<T>.empty();
        if (textEditingValue.text.isEmpty) return widget.items;
        return widget.items.where(
          (item) => widget
              .itemLabel(item)
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()),
        );
      },
      displayStringForOption: (T option) => widget.itemLabel(option),
      onSelected: (T selection) {
        widget.onSelected(selection); // call your selection callback
        _controller.text = widget.itemLabel(selection);
      },
      fieldViewBuilder:
          (context, fieldController, focusNode, onEditingComplete) {
            // Set initial text if provided
            // if (initialValue != null) {
            //   fieldController.text = itemLabel(initialValue!);
            // }
            // fieldController.text = _controller.text;
            // 🔥 Listen for focus changes (detect when field loses focus)
            focusNode.addListener(() {
              if (!focusNode.hasFocus) {
                final text = fieldController.text.trim();
                final exists = widget.items.any(
                  (item) =>
                      widget.itemLabel(item).toLowerCase() ==
                      text.toLowerCase(),
                );
                if (!exists && text.isNotEmpty && widget.onNewItem != null)
                  widget.onNewItem!(text);

                fieldController.text = text;
                fieldController.selection = TextSelection.fromPosition(
                  TextPosition(offset: text.length),
                );
                // if (onNewItem != null && text.isNotEmpty) {
                //   onNewItem!(text);
                // }
              }
            });
            return TextFormField(
              controller: fieldController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
              // Optional: detect live typing
              // onChanged: (text) {
              //   if (onNewItem != null) onNewItem!(text);
              // },
              onEditingComplete: () {
                final text = fieldController.text.trim();
                final exists = widget.items.any(
                  (item) =>
                      widget.itemLabel(item).toLowerCase() ==
                      text.toLowerCase(),
                );
                if (!exists && text.isNotEmpty && widget.onNewItem != null) {
                  widget.onNewItem!(text);

                  fieldController.text = text;
                  fieldController.selection = TextSelection.fromPosition(
                    TextPosition(offset: text.length),
                  );
                }

                onEditingComplete(); // keep Autocomplete behavior
              },
            );
          },
    );
  }
}
