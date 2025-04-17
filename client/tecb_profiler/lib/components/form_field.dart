import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

abstract class Validatable {
  bool isValid();
}

class CustomFormField extends StatefulWidget implements Validatable {
  final String label;
  final TextEditingController controller;
  final bool required;
  final TextInputType keyboardType;
  final bool enabled;  // New property to control whether the field is enabled

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,  // Default is true (enabled)
  });

  @override
  State<CustomFormField> createState() => CustomFormFieldState();

  @override
  bool isValid() => controller.text.trim().isNotEmpty;
}

class CustomFormFieldState extends State<CustomFormField> {
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.required && _showError && widget.controller.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.label,
                )),
            if (widget.required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 10),
        CupertinoTextField(
          controller: widget.controller,
          placeholder: 'Enter ${widget.label}',
          keyboardType: widget.keyboardType,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
            border: hasError ? Border.all(color: Colors.red) : null,
          ),
          onChanged: (_) {
            if (_showError && widget.controller.text.trim().isNotEmpty) {
              setState(() => _showError = false);
            }
          },
          enabled: widget.enabled,  // Use the enabled property here
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

  bool validate() {
    final isValid = widget.controller.text.trim().isNotEmpty;
    setState(() => _showError = !isValid);
    return isValid;
  }
}
