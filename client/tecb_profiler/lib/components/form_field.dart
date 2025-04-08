import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class CustomFormField extends StatelessWidget{

  final String label;
  final TextEditingController controller;
  final bool required;
  final TextInputType keyboardType;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.required = false,
    this.keyboardType = TextInputType.text,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.label,
                )),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 6),
        CupertinoTextField(
          controller: controller,
          placeholder: 'Enter $label',
          keyboardType: keyboardType,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
  
}


