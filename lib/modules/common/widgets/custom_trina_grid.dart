import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

class CustomTrinaGrid<T> extends StatelessWidget {
  final List<T> data;
  final List<TrinaColumn> columns;
  final int? sortColumnIndex;
  final bool sortAscending;
  final double rowHeight;
  // ✅ NEW fields
  // final List<TrinaCell> Function(T item) cellBuilder;
  final Map<String, TrinaCell> Function(T item) cellBuilder;
  final int Function(T item) getId;
  final void Function(T item)? onSelect;
  final int? selectedId;
  // Optional: automatic text cells
  final List<String Function(T)>? fieldGetters;
  final void Function(String field, double newWidth)? onColumnResized;

  const CustomTrinaGrid({
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
    this.onColumnResized,
    this.rowHeight = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    final rows = data.map((item) {
      // final id = getId(item);
      // final isSelected = selectedId != null && id == selectedId;
      final cells = cellBuilder(item);
      return TrinaRow(cells: cells, data: item,  height: rowHeight);
    }).toList();
    return TrinaGrid(
      columns: columns,
      rows: rows,
      configuration: const TrinaGridConfiguration(
        columnSize: TrinaGridColumnSizeConfig(
          autoSizeMode: TrinaAutoSizeMode.scale,
          resizeMode: TrinaResizeMode.normal,
        ),
      ),
      mode: TrinaGridMode.selectWithOneTap,
      onSelected: (TrinaGridOnSelectedEvent event) {
        final row = event.row;
        if (row == null) return;
        final idCell = row.cells['id'];
        final id = int.tryParse(idCell?.value.toString() ?? '');
        if (id == null) return;
        final selectedItem = row.data;

        if (selectedItem != null && onSelect != null) {
          onSelect!(selectedItem);
        }
      },


    );
  }
}
