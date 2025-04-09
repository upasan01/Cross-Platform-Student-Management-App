import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecb_profiler/components/date_picker.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/student_data_model.dart';

class AcademicsDetails extends StatefulWidget { 
  final StudentData studentData;
  const AcademicsDetails({super.key, required this.studentData});

  @override
  State<AcademicsDetails> createState() => _AcademicsDetailsState();
} 

class _AcademicsDetailsState extends State<AcademicsDetails> {
  // Controllers for all the fields
  final rollController = TextEditingController();
  final regController = TextEditingController();
  final courseController = TextEditingController();
  final graduationYearController = TextEditingController();
  final resultController = TextEditingController();
  final boardController = TextEditingController();
  final schoolController = TextEditingController();

  final List<String> courses = [
    "Computer Science & Engineering", "Computer Science & Engineering(AIML)", 
    "Electronics & Communication Engineering", "Information Technology",
    "Bachelor of Business Administration", "Bachelor of Computer Application"
  ];
  String? selectedCourse;


  void _saveData() {
    // Save the updated data back to the student form data model
    // widget.studentData.fullName = nameController.text;
    // widget.studentData.fatherName = fatherNameController.text;
    // widget.studentData.motherName = motherNameController.text;
    // widget.studentData.email = emailController.text;
    // widget.studentData.phone = phoneController.text;
    // widget.studentData.bloodGroup = selectedBloodGroup;
    // widget.studentData.gender = selectedGender;
    // widget.studentData.dob = widget.studentData.dob; // This will already be a DateTime
  }

  void _handleSubmit() {
    // if (nameController.text.isEmpty ||
    //     emailController.text.isEmpty ||
    //     phoneController.text.isEmpty) {
    //   showCupertinoDialog(
    //     context: context,
    //     builder: (context) => CupertinoAlertDialog(
    //       title: const Text("Missing Required Fields"),
    //       content: const Text("Please fill all the required fields."),
    //       actions: [
    //         CupertinoDialogAction(
    //           isDefaultAction: true,
    //           child: const Text("OK"),
    //           onPressed: () => Navigator.pop(context),
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
    //   // Proceed with next page navigation or saving data
    //   _saveData();
    //   Navigator.push(
    //     context,
    //     CupertinoPageRoute(builder: (context) => )
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Academics Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                label: "University Roll No", 
                controller: rollController,
                required: true,
                keyboardType: TextInputType.number,),

              CustomFormField(
                label: "University Registration No", 
                controller: regController,
                required: true,
                keyboardType: TextInputType.number,),
              
              CustomDropDown(
                label: 'Course',
                options: courses,
                selectedValue: selectedCourse,
                required: true,
                onTap: (value) {
                  setState(() {
                    selectedCourse = value;
                  });
                },
              ),

              CustomFormField(
                label: "Year of Graduation", 
                controller: graduationYearController,
                keyboardType: TextInputType.numberWithOptions(),),

              CustomFormField(
                label: "Class 12th or Equivalent Result(%)", 
                controller: resultController,
                keyboardType: TextInputType.numberWithOptions(),),

              CustomFormField(
                label: "Board of Institution", 
                controller: boardController,
                keyboardType: TextInputType.numberWithOptions(),),

              CustomFormField(
                label: "School Name", 
                controller: schoolController,
                keyboardType: TextInputType.text,),

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
