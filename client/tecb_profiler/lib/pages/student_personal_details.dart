import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/date_picker.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/image_picker.dart';
import 'package:tecb_profiler/pages/academics_details.dart';
import 'package:tecb_profiler/student_data_model.dart';

class StudentPersonalDetails extends StatefulWidget { 
  final StudentData studentData;
  const StudentPersonalDetails({super.key, required this.studentData});

  @override
  State<StudentPersonalDetails> createState() => _StudentPersonalDetailsState();
} 

class _StudentPersonalDetailsState extends State<StudentPersonalDetails> {
  // Controllers for all the fields
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();

  String? selectedImagePath; // For the Image Picker

  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];
  String? selectedBloodGroup;

  final List<String> genders = [
    "Male", "Female", "Prefer Not To Say"
  ];
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    nameController.text = widget.studentData.fullName;
    fatherNameController.text = widget.studentData.fatherName;
    motherNameController.text = widget.studentData.motherName;
    emailController.text = widget.studentData.email;
    phoneController.text = widget.studentData.phone;
    selectedBloodGroup = widget.studentData.bloodGroup;
    // Set initial values for gender and dob
    selectedGender = widget.studentData.gender;
  }

  void _saveData() {
    // Save the updated data back to the student form data model
    widget.studentData.fullName = nameController.text;
    widget.studentData.fatherName = fatherNameController.text;
    widget.studentData.motherName = motherNameController.text;
    widget.studentData.email = emailController.text;
    widget.studentData.phone = phoneController.text;
    widget.studentData.bloodGroup = selectedBloodGroup;
    widget.studentData.gender = selectedGender;
    widget.studentData.dob = widget.studentData.dob; // This will already be a DateTime
  }

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
      // Proceed with next page navigation or saving data
      _saveData();
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => AcademicsDetails(studentData: widget.studentData))
      );
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
              Center(
                child: CustomImagePicker(onImagePicked: (imagePath) {
                  setState(() {
                    selectedImagePath = imagePath;
                  });
                }),
              ),
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
              CustomFormField(
                label: "Address",
                controller: addressController,
                required: true,
                keyboardType: TextInputType.streetAddress,
              ),
              CustomDropDown(
                label: 'Gender',
                options: genders,
                selectedValue: selectedGender,
                required: true,
                onTap: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
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
                selectedDate: widget.studentData.dob,
                required: true,
                onTap: (selected) {
                  setState(() {
                    widget.studentData.dob = selected; // Store DateTime here
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
