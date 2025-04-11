import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

abstract class Validatable {
  bool isValid();
}

class CustomDropDown extends StatefulWidget implements Validatable {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final bool required;
  final void Function(String selected) onTap;

  const CustomDropDown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onTap,
    this.required = false,
  });

  @override
  State<CustomDropDown> createState() => CustomDropDownState();

  // Implementing the isValid method here
  @override
  bool isValid() {
    // If required, check if the selected value is not null or empty
    return required ? (selectedValue?.isNotEmpty ?? false) : true;
  }
}

class CustomDropDownState extends State<CustomDropDown> {
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.required && _showError && (widget.selectedValue?.isEmpty ?? true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontSize: 16, color: CupertinoColors.label),
            ),
            if (widget.required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showDropDown(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(8),
              border: hasError ? Border.all(color: Colors.red) : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedValue ?? 'Select ${widget.label}',
                  style: TextStyle(
                    color: widget.selectedValue != null
                        ? CupertinoColors.label
                        : CupertinoColors.placeholderText,
                  ),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 20),
              ],
            ),
          ),
        ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "This field is required",
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showDropDown(BuildContext context) {
    final initialItem = widget.selectedValue != null
        ? widget.options.indexOf(widget.selectedValue!)
        : 0;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: CupertinoPicker(
          itemExtent: 40,
          backgroundColor: CupertinoColors.systemBackground,
          scrollController: FixedExtentScrollController(initialItem: initialItem),
          onSelectedItemChanged: (index) {
            widget.onTap(widget.options[index]);
            if (_showError && widget.options[index].isNotEmpty) {
              setState(() => _showError = false);
            }
          },
          children: widget.options.map((option) => Text(option)).toList(),
        ),
      ),
    );
  }

  bool validate() {
    final isValid = widget.selectedValue?.isNotEmpty ?? false;
    setState(() => _showError = !isValid);
    return isValid;
  }
}
