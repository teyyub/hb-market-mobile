import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownSelector<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final List<T> items;
  final void Function(T) onChanged;
  final String Function(T) itemLabel;
  final bool searchable;

  const DropdownSelector({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.searchable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchable) {
      // Use DropdownSearch
      return DropdownSearch<T>(
        items: (filter, infiniteScrollProps) => items,
        selectedItem: selectedValue,
        itemAsString: (T item) => itemLabel(item),
        // dropdownSearchDecoration: InputDecoration(
        //   labelText: label,
        //   border: const OutlineInputBorder(),
        // ),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      );
    } else {
      return DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(itemLabel(item)));
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      );
    }
  }
}
