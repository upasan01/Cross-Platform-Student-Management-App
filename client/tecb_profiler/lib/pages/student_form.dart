import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final rollNoController = TextEditingController();
  final regNoController = TextEditingController();
  final bloodGroupController = TextEditingController();

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
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

  void _handleSubmit() {
    if (nameController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        rollNoController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Missing Required Fields"),
          content: const Text("Please fill all the required fields."),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Form Submitted"),
          content: const Text("Student details have been recorded."),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Student Details Form'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(
                label: 'Full Name',
                controller: nameController,
                required: true,
              ),
              _buildField(
                label: 'Father\'s Name',
                controller: fatherNameController,
                required: true,
              ),
              _buildField(
                label: 'Mother\'s Name',
                controller: motherNameController,
              ),
              _buildField(
                label: 'Registration No',
                controller: regNoController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              _buildField(
                label: 'University Roll No',
                controller: rollNoController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              _buildField(
                label: 'Blood Group',
                controller: bloodGroupController,
              ),
              const SizedBox(height: 30),
              Center(
                child: CupertinoButton.filled(
                  child: const Text('Submit'),
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
