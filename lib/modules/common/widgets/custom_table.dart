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
      rows: rowBuilder(data),
    );
  }
}
