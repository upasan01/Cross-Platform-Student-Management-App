import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/pages/general_details.dart';
import 'package:tecb_profiler/pages/getting_started.dart';
import 'package:tecb_profiler/student_data_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final studentData =  StudentData(
      permanentAddress: Address(), 
      residentialAddress: Address(), 
      father: Parent(),
      mother: Parent(),
      academic: AcademicDetails()
      );
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'TECB Profiler',
      home: StudentGeneralDetails(studentData: studentData),
    );
  }
}
