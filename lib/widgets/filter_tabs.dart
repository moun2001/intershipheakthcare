import 'package:flutter/material.dart';

class FilterTabs extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const FilterTabs({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ToggleButtons(
        isSelected: List.generate(options.length, (index) => index == selectedIndex),
        onPressed: onChanged,
        borderRadius: BorderRadius.circular(8),
        selectedBorderColor: theme.colorScheme.primary,
        selectedColor: Colors.white,
        fillColor: theme.colorScheme.primary,
        color: theme.colorScheme.onSurface,
        constraints: BoxConstraints(
          minHeight: 40,
          minWidth: (MediaQuery.of(context).size.width - 64) / options.length,
        ),
        children: options.map((option) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            option,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        )).toList(),
      ),
    );
  }
}
