import 'package:flutter/material.dart';

class ColumnVisibilityMenu extends StatelessWidget {
  final List<Map<String, dynamic>> columns;
  final void Function(String key, bool visible) onChanged;

  const ColumnVisibilityMenu({
    super.key,
    required this.columns,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      icon: const Icon(Icons.view_column),
      tooltip: 'Goster/Gizle',
      itemBuilder: (context) {
        return columns.map((col) {
          return PopupMenuItem<void>(
            child: StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  value: col['visible'],
                  title: Text(col['label']),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => col['visible'] = val);
                    onChanged(col['key'], val);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          );
        }).toList();
      },
    );
  }
}
