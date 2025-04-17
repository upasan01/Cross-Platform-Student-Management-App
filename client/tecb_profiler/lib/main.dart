import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/pages/getting_started.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'TECB Profiler',
      home: GettingStartedPage(),
    );
  }
}
