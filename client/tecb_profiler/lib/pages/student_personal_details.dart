import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/date_picker.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';

class StudentPersonalDetails extends StatefulWidget {
  const StudentPersonalDetails({super.key});

  @override
  State<StudentPersonalDetails> createState() => _StudentPersonalDetailsState();
} 

class _StudentPersonalDetailsState extends State<StudentPersonalDetails> {
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final dobController = TextEditingController();

  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];
  String? selectedBloodGroup;

  void _handleNext() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
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
      // // Navigate to the second page
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => const NextPage(),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Student Personal Details'),
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
              ),
              CustomFormField(
                label: 'Mother\'s Name',
                controller: motherNameController,
              ),
              CustomFormField(
                label: 'Email ID',
                controller: emailController,
                required: true,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomFormField(
                label: 'Phone',
                controller: phoneController,
                required: true,
                keyboardType: TextInputType.phone,
              ),
              CustomDropDown(
                label: 'Blood Group', 
                options: bloodGroups,
                selectedValue: selectedBloodGroup,
                required: true,
                onTap: (value) {
                  setState(() {
                    selectedBloodGroup = value;
                  });
                },
              ),
              CustomDatePicker(
                label: 'Date of Birth',
                selectedDate: dobController.text.isEmpty ? null : dobController.text,
                required: true,
                onTap: (selected) {
                  setState(() {
                    dobController.text = selected;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: CupertinoButton.filled(
                  onPressed: _handleNext,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
