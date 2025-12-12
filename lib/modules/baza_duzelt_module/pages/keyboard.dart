  import 'package:flutter/material.dart';

  class NumberSymbolKeyboard extends StatelessWidget {
    final Function(String) onKeyPressed;

    NumberSymbolKeyboard({super.key, required this.onKeyPressed});

    final List<String> keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
      '.',
      '+',
      '-',
      '*',
      '/',
      '⌫',
      '⏎',
      '✖',
    ];

    @override
    Widget build(BuildContext context) {
      return GridView.builder(
        shrinkWrap: true,
        itemCount: keys.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (BuildContext context, int index) {
          return AspectRatio(
            aspectRatio: 0.8, // width = height → makes it square
            child: ElevatedButton(
              onPressed: () => onKeyPressed(keys[index]),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(30, 20),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // no rounded corners
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(keys[index], style: const TextStyle(fontSize: 14)),
            ),
          );
        },
      );
    }
  }
