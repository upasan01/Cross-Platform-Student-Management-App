import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/pages/signup_page.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text('Success'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: CupertinoColors.activeGreen,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Data Recorded Successfully!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Thank you for your submission.',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'You may close the app.',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20), // Padding above the text
                child: GestureDetector(
                  onTap: () {
                    // Handle tap here (e.g., navigate to Login page)
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => SignUpPage())
                    );
                  },
                  child: Text(
                    'Create another Profile?',
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.activeBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
