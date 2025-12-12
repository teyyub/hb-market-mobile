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

  bool _defaultCompare(T a, T b) {
    // If T is primitive, just use ==
    if (a is String || a is int || a is double) return a == b;

    // If object has 'id', compare by id
    try {
      final aId = (a as dynamic).id;
      final bId = (b as dynamic).id;
      return aId == bId;
      // if (aId != 0 && bId != 0) return aId == bId;
      // fallback: compare by text if id is 0
      // return (a as dynamic).ad == (b as dynamic).ad;
    } catch (_) {
      // fallback to object equality
      return a == b;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (searchable) {
      // // Use DropdownSearch
      return DropdownSearch<T>(
        items: (String filter, LoadProps? infiniteScrollProps) => items,
        selectedItem: selectedValue,
        itemAsString: (T item) => itemLabel(item),
        compareFn: _defaultCompare,
        decoratorProps:  DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        popupProps: PopupProps.menu(showSearchBox: true),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      );

    } else {
      return DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        initialValue: selectedValue,
        items: items.map((item) {

          return DropdownMenuItem(value: item,
              child: Text(itemLabel(item),
                overflow: TextOverflow.ellipsis,
                // style: const TextStyle(
                //   fontSize: 14, // <-- change font size here
                // ),// truncate long text
                maxLines: 1, ));
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      );
    }
  }
}
