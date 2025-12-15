// import 'package:flutter/material.dart';
// import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
// import 'package:hbmarket/modules/common/widgets/custom_trina_grid.dart';
// import 'package:trina_grid/trina_grid.dart';
//
// class TrinaGridWidget<T> extends StatelessWidget {
//   final List<T> data;
//   final dynamic selectedId;
//   final Function(T)? onSelect;
//   final List<Map<String, dynamic>> columns;
//   final Map<String, double>? initialColumnWidths;
//   final int Function(T) getId;
//   final void Function(String key, bool visible)? onColumnVisibilityChanged;
//   final void Function(String key, double newWidth)? onColumnResize;
//   final Map<String, TrinaCell> Function(T)? cellBuilder;
//
//   const TrinaGridWidget({
//     Key? key,
//     required this.data,
//     required this.selectedId,
//     required this.columns,
//     required this.getId,
//     this.onSelect,
//     this.initialColumnWidths,
//     this.onColumnVisibilityChanged,
//     this.onColumnResize,
//     this.cellBuilder,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final savedColumnWidths = initialColumnWidths ?? {};
//
//     final visibleColumns = columns.where((c) => c['visible'] == true).toList();
//
//     final displayColumns = visibleColumns.isNotEmpty
//         ? visibleColumns
//         : [
//             {'key': 'placeholder', 'label': 'Bosdur', 'visible': true},
//           ];
//
//     // final displayColumns = visibleColumns.isNotEmpty ? visibleColumns : columns;
//
//     return Column(
//       children: [
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.end,
//         //   children: [
//         //     ColumnVisibilityMenu(
//         //       columns: columns,
//         //       onChanged: (key, visible) {
//         //         if (onColumnVisibilityChanged != null) {
//         //           onColumnVisibilityChanged!(key, visible);
//         //         }
//         //       },
//         //     ),
//         //   ],
//         // ),
//         const SizedBox(height: 4),
//         Expanded(
//           child: CustomTrinaGrid<T>(
//             key: ValueKey('${columns.map((Map<String, dynamic> c) => c['visible']).join()}'),
//             data: data,
//             selectedId: selectedId,
//             onSelect: onSelect,
//             getId: getId,
//             columns: displayColumns
//                 .map(
//                   (c) => TrinaColumn(
//                     title: c['label'],
//                     field: c['key'],
//                     type: TrinaColumnType.text(),
//                     width: savedColumnWidths[c['key']] ?? 100,
//                     enableContextMenu: false,
//
//                   ),
//                 )
//                 .toList(),
//             cellBuilder: (item) {
//               if (cellBuilder != null) {
//                 return cellBuilder!(item);
//               }
//               // Default cell mapping if cellBuilder not provided
//               final Map<String, TrinaCell> cells = {};
//               for (final Map<String, dynamic> c in displayColumns) {
//                 cells[c['key']] = TrinaCell(value: '');
//               }
//               return cells;
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
