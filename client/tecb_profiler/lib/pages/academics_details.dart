import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/services/api_services.dart';
import 'package:tecb_profiler/services/jwt_actions.dart';
import 'package:tecb_profiler/student_data_model.dart';

class AcademicsDetails extends StatefulWidget {
  final StudentData studentData;
  const AcademicsDetails({super.key, required this.studentData});

  @override
  State<AcademicsDetails> createState() => _AcademicsDetailsState();
}

class _AcademicsDetailsState extends State<AcademicsDetails> {
  final rollController = TextEditingController();
  final regController = TextEditingController();
  final graduationYearController = TextEditingController();
  final resultController = TextEditingController();
  final boardController = TextEditingController();
  final schoolController = TextEditingController();

  final rollFieldKey = GlobalKey<CustomFormFieldState>();
  final regNoFieldKey = GlobalKey<CustomFormFieldState>();
  final courseFieldKey = GlobalKey<CustomDropDownState>();
  final resultFieldKey = GlobalKey<CustomFormFieldState>();
  final yOfGraduationFieldKey = GlobalKey<CustomFormFieldState>();

  final List<String> courses = [
    "Computer Science & Engineering",
    "Computer Science & Engineering(AIML)",
    "Electronics & Communication Engineering",
    "Information Technology",
    "Bachelor of Business Administration",
    "Bachelor of Computer Application"
  ];

  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    rollController.text = widget.studentData.roll?.toString() ?? '';
    regController.text = widget.studentData.regNo?.toString() ?? '';
    resultController.text = widget.studentData.result?.toString() ?? '';
    graduationYearController.text = widget.studentData.yOfGraduation;
    schoolController.text = widget.studentData.schoolName;
    selectedCourse = widget.studentData.course;
    boardController.text = widget.studentData.boardOfEducation;
  }

  void _saveData() {
    widget.studentData.roll = int.tryParse(rollController.text) ?? 0;
    widget.studentData.regNo = int.tryParse(regController.text) ?? 0;
    widget.studentData.course = selectedCourse;
    widget.studentData.result = double.tryParse(resultController.text) ?? 0.0;
    widget.studentData.boardOfEducation = boardController.text;
    widget.studentData.yOfGraduation = graduationYearController.text;
    widget.studentData.schoolName = schoolController.text;
  }

  Future<void> _handleSubmit() async {
    final allFormsValid = [
      rollFieldKey,
      regNoFieldKey,
      yOfGraduationFieldKey,
      resultFieldKey
    ].every((key) => key.currentState?.validate() ?? false);

    final allDropDownValid = [courseFieldKey]
        .every((key) => key.currentState?.validate() ?? false);

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
      final token = await TokenStorage.getToken();
      if (token == null) {
        ErrorDialogUtility.showErrorDialog(
          context,
          errorMessage: "Token Unavailable",
        );
        return;
      }

      final response = await ApiService.sendFormData(
        studentData: widget.studentData,
        token: token,
      );

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        ErrorDialogUtility.showErrorDialog(
          context,
          errorMessage: "Recorded Successfully:\n$body",
        );
      } else {
        final errorBody = await response.stream.bytesToString();
        print(errorBody);
        ErrorDialogUtility.showErrorDialog(
          context,
          errorMessage:
              "Failed to submit. Status code: ${response.statusCode}\n$errorBody",
        );
      }
    } catch (error) {
      ErrorDialogUtility.showErrorDialog(
        context,
        errorMessage: error.toString(),
      );
    }
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
                key: rollFieldKey,
                label: "University Roll No",
                controller: rollController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              CustomFormField(
                key: regNoFieldKey,
                label: "University Registration No",
                controller: regController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              CustomDropDown(
                key: courseFieldKey,
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
                key: yOfGraduationFieldKey,
                label: "Year of Graduation",
                controller: graduationYearController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              CustomFormField(
                key: resultFieldKey,
                label: "Class 12th or Equivalent Result(%)",
                controller: resultController,
                required: true,
                keyboardType: TextInputType.number,
              ),
              CustomFormField(
                label: "Board of Institution",
                controller: boardController,
              ),
              CustomFormField(
                label: "School Name",
                controller: schoolController,
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
