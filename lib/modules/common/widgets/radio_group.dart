import 'package:flutter/material.dart';

class RadioGroupComponent<T> extends StatelessWidget {
  final T value; // current selected value
  final void Function(T) onChanged;
  final List<RadioGroupItem<T>> items;
  final Axis direction;

  const RadioGroupComponent({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: value,
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
      child: direction == Axis.horizontal
          ? Row(
              children: items
                  .map(
                    (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<T>(value: item.value),
                        Text(item.label),
                      ],
                    ),
                  )
                  .toList(),
            )
          : Column(
              children: items
                  .map(
                    (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<T>(value: item.value),
                        Text(item.label),
                      ],
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class RadioGroupItem<T> {
  final String label;
  final T value;
  const RadioGroupItem({required this.label, required this.value});
}
