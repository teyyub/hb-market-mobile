import 'package:flutter/material.dart';

import '../../baza_duzelt_module/pages/keyboard.dart';


class CustomKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String key)? onSubmit; // ⏎ düyməsi üçün callback

  const CustomKeyboard({
    Key? key,
    required this.controller,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: NumberSymbolKeyboard(
        onKeyPressed: (String key) {
          final text = controller.text;
          final selection = controller.selection;
          final start = selection.start >= 0 ? selection.start : text.length;
          final end = selection.end >= 0 ? selection.end : text.length;

          switch (key) {
            case '⌫':
              if (start != end) {
                controller.text = text.replaceRange(start, end, '');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: start),
                );
              } else if (start > 0) {
                final newStart = start - 1;
                controller.text = text.replaceRange(newStart, start, '');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: newStart),
                );
              }
              break;
            case '✖':
              controller.clear();
              break;
            case '⏎':
              if (onSubmit != null) onSubmit!(controller.text);
              break;
            default:
              final newText = text.replaceRange(start, end, key);
              controller.text = newText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: start + key.length),
              );
          }
        },
      ),
    );
  }
}
