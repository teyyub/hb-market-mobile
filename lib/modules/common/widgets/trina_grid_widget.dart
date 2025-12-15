import 'package:flutter/material.dart';
import 'package:hbmarket/modules/common/widgets/custom_trina_grid.dart';
import 'package:trina_grid/trina_grid.dart';

class TrinaGridWidget<T> extends StatefulWidget {
  final List<T> data;
  final dynamic selectedId;
  final Function(T)? onSelect;
  final List<Map<String, dynamic>> columns;
  final Map<String, double>? initialColumnWidths;
  final int Function(T) getId;
  final void Function(String key, bool visible)? onColumnVisibilityChanged;
  final void Function(String key, double newWidth)? onColumnResize;
  final Map<String, TrinaCell> Function(T)? cellBuilder;

  const TrinaGridWidget({
    Key? key,
    required this.data,
    required this.selectedId,
    required this.columns,
    required this.getId,
    this.onSelect,
    this.initialColumnWidths,
    this.onColumnVisibilityChanged,
    this.onColumnResize,
    this.cellBuilder,
  }) : super(key: key);

  @override
  State<TrinaGridWidget<T>> createState() => _TrinaGridWidgetState<T>();
}

class _TrinaGridWidgetState<T> extends State<TrinaGridWidget<T>> {
  dynamic _selectedId;
  @override
  void initState() {
    super.initState();
    // Default olaraq ilk item seçilsin
    if (widget.selectedId == null && widget.data.isNotEmpty) {
      _selectedId = widget.getId(widget.data.first);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelect?.call(widget.data.first);
      });
    } else {
      _selectedId = widget.selectedId;
    }
  }
@override
  Widget build(BuildContext context) {
    final savedColumnWidths = widget.initialColumnWidths ?? {};

    final visibleColumns = widget.columns.where((c) => c['visible'] == true).toList();

    final displayColumns = visibleColumns.isNotEmpty
        ? visibleColumns
        : [
            {'key': 'placeholder', 'label': 'Bosdur', 'visible': true},
          ];

    return Column(
      children: [
        const SizedBox(height: 4),
        Expanded(
          child: CustomTrinaGrid<T>(
            key: ValueKey('${widget.columns.map((Map<String, dynamic> c) => c['visible']).join()}'),
            data: widget.data,
            selectedId: _selectedId,
            onSelect: (item) {
              setState(() {
                _selectedId = widget.getId(item);
              });
              widget.onSelect?.call(item);
            },
            getId: widget.getId,
            columns: displayColumns
                .map(
                  (c) => TrinaColumn(
                    title: c['label'],
                    field: c['key'],
                    type: TrinaColumnType.text(),
                    width: savedColumnWidths[c['key']] ?? 100,
                    enableContextMenu: false,

                  ),
                )
                .toList(),
            cellBuilder: (item) {
              if (widget.cellBuilder != null) {
                return widget.cellBuilder!(item);
              }
              // Default cell mapping if cellBuilder not provided
              final Map<String, TrinaCell> cells = {};
              for (final Map<String, dynamic> c in displayColumns) {
                cells[c['key']] = TrinaCell(value: '');
              }
              return cells;
            },
          ),
        ),
      ],
    );
  }
}
