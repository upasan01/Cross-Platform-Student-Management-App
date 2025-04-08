import 'package:flutter/cupertino.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo 
              Image(image: AssetImage('images/techno_logo.png')),

              const SizedBox(height: 40),

              // Title Text
              const Text(
                'Welcome to TECB Profiler',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                'Your journey starts here. Let’s help you get set up quickly and easily.',
                style: TextStyle(
                  fontSize: 20,
                  color: CupertinoColors.secondaryLabel,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 50),

              // Get Started Button
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  // Handle navigation or action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
