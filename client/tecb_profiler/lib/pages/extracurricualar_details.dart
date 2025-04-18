import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/components/utils/popup_message.dart';
import 'package:tecb_profiler/pages/success_page.dart';
import 'package:tecb_profiler/services/api_services.dart';
import 'package:tecb_profiler/services/jwt_actions.dart';
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


    void _showLoadingPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // Prevents dismissal by tapping outside
      builder: (BuildContext context) {
        return Container(
          height: 150,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: CupertinoColors.activeBlue,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text('Please wait...'),
              ],
            ),
          ),
        );
      },
    );
  }


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

    void _handleNext() async {
    _saveData();
    final data = widget.studentData;
    if (data == null) return;

    _showLoadingPopup(context); // Show loading popup

    try {
      final token = await TokenStorage.getToken();
      if (!mounted) return;

      if (token == null) {
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading popup
        ErrorDialogUtility.showErrorDialog(
          context,
          errorMessage: "Invalid Token",
        );
        return;
      }

      final imageResponse = await ServerApiService.uploadImage(studentData: data, token: token);
      if (imageResponse.statusCode == 200) {
        CupertinoPopupMessage.show(context, "Image Uploaded Successfully!");
      }

      final formDataResponse = await ServerApiService.sendStudentInfo(data: data, token: token);

      Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading popup

      if (formDataResponse.statusCode == 200) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => SuccessPage()),
        );
      } else {
        ErrorDialogUtility.showErrorDialog(
          context,
          errorMessage: formDataResponse.body.toString(),
        );
      }
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading popup
      ErrorDialogUtility.showErrorDialog(
        context,
        errorMessage: error.toString(),
      );
    }
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
