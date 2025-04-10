import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/date_picker.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/image_picker.dart';
import 'package:tecb_profiler/pages/academics_details.dart';
import 'package:tecb_profiler/student_data_model.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';

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

  // GlobalKeys for validating required CustomFormFields
  final nameFieldKey = GlobalKey<CustomFormFieldState>();
  final emailFieldKey = GlobalKey<CustomFormFieldState>();
  final phoneFieldKey = GlobalKey<CustomFormFieldState>();
  final addressFieldKey = GlobalKey<CustomFormFieldState>();
  final genderFieldKey = GlobalKey<CustomDropDownState>();

  String? selectedImagePath;

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
    phoneController.text = widget.studentData.phone?.toString() ?? '';
    selectedBloodGroup = widget.studentData.bloodGroup;
    selectedGender = widget.studentData.gender;
    selectedImagePath = widget.studentData.imagePath;
    addressController.text = widget.studentData.address;
  }

  void _saveData() {
    widget.studentData.fullName = nameController.text;
    widget.studentData.fatherName = fatherNameController.text;
    widget.studentData.motherName = motherNameController.text;
    widget.studentData.email = emailController.text;
    widget.studentData.phone = int.parse(phoneController.text);
    widget.studentData.bloodGroup = selectedBloodGroup;
    widget.studentData.gender = selectedGender;
    widget.studentData.dob = widget.studentData.dob;
    widget.studentData.imagePath = selectedImagePath;
    widget.studentData.address = addressController.text;
  }

  void _handleNext() {
    // Validate all required fields
    final allFormsValid = [
      nameFieldKey,
      emailFieldKey,
      phoneFieldKey,
      addressFieldKey
    ].every((key) => key.currentState?.validate() ?? false);

    final allDropDownValid = [
      genderFieldKey,
    ].every((key)=> key.currentState?.validate() ?? false);

    if (!allFormsValid || !allDropDownValid) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Missing Required Fields"),
          content: const Text("Please fill all the required fields."),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      _saveData(); 
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              AcademicsDetails(studentData: widget.studentData),
        ),
      );
    } catch (error) {
      ErrorDialogUtility.showErrorDialog(
        context,
        errorMessage: error.toString());
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
                child: CustomImagePicker(
                  onImagePicked: (imagePath) {
                    setState(() {
                      selectedImagePath = imagePath;
                    });
                  },
                ),
              ),
              CustomFormField(
                key: nameFieldKey,
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
                key: emailFieldKey,
                label: 'Email ID',
                controller: emailController,
                required: true,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomFormField(
                key: phoneFieldKey,
                label: 'Phone',
                controller: phoneController,
                required: true,
                keyboardType: TextInputType.phone,
              ),
              CustomFormField(
                key: addressFieldKey,
                label: 'Address',
                controller: addressController,
                required: true,
                keyboardType: TextInputType.streetAddress,
              ),
              CustomDropDown(
                key: genderFieldKey,
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
                    widget.studentData.dob = selected;
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
