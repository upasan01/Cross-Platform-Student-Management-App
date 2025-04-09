import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate; // Change to DateTime?
  final bool required;
  final void Function(DateTime selected) onTap; // Change to DateTime

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onTap,
    this.required = false,
  });

  void _showDatePicker(BuildContext context) {
    final initialDate = selectedDate ?? DateTime.now(); // Handle null date

    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          initialDateTime: initialDate,
          minimumYear: 1900,
          maximumYear: DateTime.now().year,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime newDateTime) {
            onTap(newDateTime); // Pass DateTime object to onTap
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, color: CupertinoColors.label),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                      : 'Select $label',
                  style: TextStyle(
                    color: selectedDate != null
                        ? CupertinoColors.label
                        : CupertinoColors.placeholderText,
                  ),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
