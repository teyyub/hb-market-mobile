import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CustomDataTable<T> extends StatelessWidget {
  final List<T> data;
  final int? sortColumnIndex;
  final bool sortAscending;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T> data) rowBuilder;

  const CustomDataTable({
    super.key,
    required this.data,
    required this.columns,
    required this.rowBuilder,
    this.sortColumnIndex,
    this.sortAscending = true,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      columnSpacing: 12,
      horizontalMargin: 12,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      columns: columns,
      rows: rowBuilder(data),
    );
  }
}
