import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';


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

  
  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];
  String? selectedBloodGroup;
  

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
          
              CustomFormField(
                label: 'Full Name',
                controller: nameController,
                required: true,
              ),
              CustomFormField(
                label: 'Father\'s Name',
                controller: fatherNameController,
                required: true,
              ),
              CustomFormField(
                label: 'Mother\'s Name',
                controller: motherNameController,
              ),
              CustomFormField(
                label: 'Registration No',
                controller: regNoController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              CustomFormField(
                label: 'University Roll No',
                controller: rollNoController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              CustomDropDown(
                label: 'Blood Group',
                options: bloodGroups,
                selectedValue: selectedBloodGroup,
                onTap: (value) {
                  setState(() {
                    selectedBloodGroup = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: CupertinoButton.filled(
                  onPressed: _handleSubmit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
