import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CustomDataTable2<T> extends StatelessWidget {
  final List<T> data;
  final int? sortColumnIndex;
  final bool sortAscending;
  final List<DataColumn> columns;
  // ✅ NEW fields
  final List<DataCell> Function(T item) cellBuilder;
  final int Function(T item) getId;
  final void Function(int id)? onSelect;
  final int? selectedId;
  // Optional: automatic text cells
  final List<String Function(T)>? fieldGetters;

  const CustomDataTable2({
    super.key,
    required this.data,
    required this.columns,
    required this.cellBuilder,
    required this.getId,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelect,
    this.selectedId,
    this.fieldGetters,
  });

  @override
  Widget build(BuildContext context) {
    final int? effectiveSelectedId =
        selectedId ?? (data.isNotEmpty ? getId(data.first) : null);

    return DataTable2(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
      headingTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black87,
      ),
      columnSpacing: 10,
      horizontalMargin: 10,
      dataRowHeight: 60,
      headingRowHeight: 60,
      dividerThickness: 2.0,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      columns: columns,
      rows: data.map((item) {
        final id = getId(item);
        final isSelected = id == effectiveSelectedId;

        return DataRow(
          selected: isSelected,
          onSelectChanged: (selected) {
            if (selected == true && onSelect != null) {
              onSelect!(id);
            }
          },
          color: WidgetStateProperty.resolveWith<Color?>(
            (states) => isSelected ? Colors.blue.withOpacity(0.2) : null,
          ),
          cells: cellBuilder(item),
        );
      }).toList(),
    );
  }
}
