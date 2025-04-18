import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/student_data_model.dart';

class StudentExtracurricularDetailsPage extends StatefulWidget {
  final StudentData? studentData;
  const StudentExtracurricularDetailsPage({super.key, required this.studentData});

  @override
  State<StudentExtracurricularDetailsPage> createState() => _StudentExtracurricularDetailsPageState();
}

class _StudentExtracurricularDetailsPageState extends State<StudentExtracurricularDetailsPage> {
  // Controllers
  final hobbiesController = TextEditingController();
  final domainInterestController = TextEditingController();
  final bestSubjectController = TextEditingController();
  final leastSubjectController = TextEditingController();

  void _saveData() {
    final data = widget.studentData;
    if (data == null) return;
    data.extraCurricular = ExtraCurricularDetails(
      hobbies: hobbiesController.text,
      interestedDomain: domainInterestController.text,
      subjectBest: bestSubjectController.text,
      subjectLeast: leastSubjectController.text
    );
  }

  void _handleNext() {
    _saveData();
    widget.studentData?.printStudentData();
  }

  @override
  void initState() {
    super.initState();
    final data = widget.studentData;
    if (data == null) return;
    if(data.extraCurricular == null){
      ExtraCurricularDetails();
      return;
    }
 
    hobbiesController.text = data.extraCurricular!.hobbies;
    domainInterestController.text = data.extraCurricular!.interestedDomain;
    bestSubjectController.text = data.extraCurricular!.subjectBest;
    leastSubjectController.text = data.extraCurricular!.subjectLeast;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Extracurricular Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                label: "Hobbies",
                controller: hobbiesController,
              ),
              CustomFormField(
                label: "Interested Domain",
                controller: domainInterestController,
              ),
              CustomFormField(
                label: "Subject with Best Emphasis",
                controller: bestSubjectController,
              ),
              CustomFormField(
                label: "Subject with Least Emphasis",
                controller: leastSubjectController,
              ),
              const SizedBox(height: 30),
              Center(
                child: CupertinoButton.filled(
                  child: const Text('Submit'),
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
