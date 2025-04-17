import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/components/utils/validiation_dialog.dart';
import 'package:tecb_profiler/student_data_model.dart';

class StudentAcademicDetailsPage extends StatefulWidget {
  final StudentData? studentData;
  const StudentAcademicDetailsPage({super.key, required this.studentData});

  @override
  State<StudentAcademicDetailsPage> createState() => _StudentAcademicDetailsPageState();
}

class _StudentAcademicDetailsPageState extends State<StudentAcademicDetailsPage> {
  //Global Keys
  final hsResultFieldKey = GlobalKey<CustomFormFieldState>();
  final hsBoardFieldKey = GlobalKey<CustomFormFieldState>();
  final hsPassYearFieldKey = GlobalKey<CustomFormFieldState>();
  final secResultFieldKey = GlobalKey<CustomFormFieldState>();
  final secBoardFieldKey = GlobalKey<CustomFormFieldState>();
  final secPassYearFieldKey = GlobalKey<CustomFormFieldState>();
  final cgpaFieldKey = GlobalKey<CustomFormFieldState>();
  final collegeFieldKey = GlobalKey<CustomFormFieldState>();
  final streamFieldKey = GlobalKey<CustomFormFieldState>();
  final colPassYearFieldKey = GlobalKey<CustomFormFieldState>();


  // Higher Secondary
  final hsPercentageController = TextEditingController();
  final hsBoardController = TextEditingController();
  final hsPassingYearController = TextEditingController();
  final hsSchoolNameController = TextEditingController();

  // Secondary
  final secPercentageController = TextEditingController();
  final secBoardController = TextEditingController();
  final secPassingYearController = TextEditingController();
  final secSchoolNameController = TextEditingController();

  // Diploma
  final diplomaCGPAController = TextEditingController();
  final diplomaCollegeNameController = TextEditingController();
  final diplomaStreamController = TextEditingController();
  final diplomaPassingYearController = TextEditingController();

  bool get isLateral => widget.studentData?.type.toLowerCase() == "lateral";
  bool get isRegular => widget.studentData?.type.toLowerCase() == "regular";

  void _saveData() {
    final data = widget.studentData;
    if (data == null) return;

    // Save Higher Secondary if Regular

    data.academic.hsPercentage = hsPercentageController.text;
    data.academic.hsBoard = hsBoardController.text;
    data.academic.hsPassingYear = hsPassingYearController.text;
    data.academic.hsSchoolName = hsSchoolNameController.text;


    // Save Secondary
    data.academic.secondaryPercentage = secPercentageController.text;
    data.academic.secondaryBoard = secBoardController.text;
    data.academic.secondaryPassingYear = secPassingYearController.text;
    data.academic.secondarySchoolName = secSchoolNameController.text;

    // Save Diploma if Lateral
    if (isLateral) {
      data.academic.diplomaCGPA = diplomaCGPAController.text;
      data.academic.diplomaCollege = diplomaCollegeNameController.text;
      data.academic.diplomaStream = diplomaStreamController.text;
      data.academic.diplomaPassingYear = diplomaPassingYearController.text;
    }
  }

  void _handleNext() {
    List<GlobalKey<CustomFormFieldState>> allFormFieldKeys = [
      secResultFieldKey,
      secBoardFieldKey,
      secPassYearFieldKey,
    ];

    if (isRegular) {
      allFormFieldKeys.addAll([
        hsResultFieldKey,
        hsBoardFieldKey,
        hsPassYearFieldKey,
      ]);
    } else{
      allFormFieldKeys.addAll([
        cgpaFieldKey,
        collegeFieldKey,
        streamFieldKey,
        colPassYearFieldKey,
      ]);
    }

    final allFormFieldsValid = allFormFieldKeys.every((key) => key.currentState?.validate() ?? false);

    if (!allFormFieldsValid) {
      ValidationDialog.show(context: context);
      return;
    }

    _saveData();
    widget.studentData?.printStudentData();
    
  }

  @override
  void initState() {
    super.initState();
    final data = widget.studentData;
    if (data == null) return;
    hsPercentageController.text = data.academic.hsPercentage;
    hsBoardController.text = data.academic.hsBoard;
    hsPassingYearController.text = data.academic.hsPassingYear;
    hsSchoolNameController.text = data.academic.hsSchoolName;


    secPercentageController.text = data.academic.secondaryPercentage;
    secBoardController.text = data.academic.secondaryBoard;
    secPassingYearController.text = data.academic.secondaryPassingYear;
    secSchoolNameController.text = data.academic.secondarySchoolName;

    if (isLateral) {
      diplomaCGPAController.text = data.academic.diplomaCGPA;
      diplomaCollegeNameController.text = data.academic.diplomaCollege;
      diplomaStreamController.text = data.academic.diplomaStream;
      diplomaPassingYearController.text = data.academic.diplomaPassingYear;
    } else {
      diplomaCGPAController.clear();
      diplomaCollegeNameController.clear();
      diplomaStreamController.clear();
      diplomaPassingYearController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Student Academic Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Higher Secondary Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomFormField(
                key: hsResultFieldKey,
                label: "Higher Secondary or Equivalent Percentage",
                controller: hsPercentageController,
                required: isRegular,
              ),
              CustomFormField(
                key: hsBoardFieldKey,
                label: "HS Board of Institution",
                controller: hsBoardController,
                required: isRegular,
              ),
              CustomFormField(
                key: hsPassYearFieldKey,
                label: "HS Passing Year",
                controller: hsPassingYearController,
                required: isRegular,
              ),
              CustomFormField(
                label: "HS School Name",
                controller: hsSchoolNameController,
              ),
              const SizedBox(height: 20),

              const Text('Secondary Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomFormField(
                key: secResultFieldKey,
                label: "Secondary or Equivalent Percentage",
                controller: secPercentageController,
                required: true,
              ),
              CustomFormField(
                key: secBoardFieldKey,
                label: "Board of Institution",
                controller: secBoardController,
                required: true,
              ),
              CustomFormField(
                key: secPassYearFieldKey,
                label: "Passing Year",
                controller: secPassingYearController,
                required: true,
              ),
              CustomFormField(
                label: "School Name",
                controller: secSchoolNameController,
              ),
              const SizedBox(height: 20),

              if (isLateral) ...[
                const Text('Diploma Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                CustomFormField(
                  key: cgpaFieldKey,
                  label: "CGPA",
                  controller: diplomaCGPAController,
                  required: true,
                ),
                CustomFormField(
                  key: collegeFieldKey,
                  label: "College/University Name",
                  controller: diplomaCollegeNameController,
                  required: true,
                ),
                CustomFormField(
                  key: streamFieldKey,
                  label: "Stream",
                  controller: diplomaStreamController,
                  required: true,
                ),
                CustomFormField(
                  key: colPassYearFieldKey,
                  label: "Passing Year",
                  controller: diplomaPassingYearController,
                  required: true,
                ),
              ] ,

              const SizedBox(height: 30),
              Center(
                child: CupertinoButton.filled(
                  child: const Text('Next'),
                  onPressed: () {
                    try {
                      _handleNext();
                    } catch (error) {
                      ErrorDialogUtility.showErrorDialog(
                        context,
                        errorMessage: error.toString(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
