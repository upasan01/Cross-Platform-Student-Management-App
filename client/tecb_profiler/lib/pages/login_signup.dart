import 'package:flutter/cupertino.dart';

class LoginSignupPage extends StatelessWidget {
  const LoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Login / Signup'),
        ),
        child: SafeArea(
          child: Container(
            color: CupertinoColors.systemGrey6, // Light grey background
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 400, // Limit max width for larger screens
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Image.asset('images/techno_logo.png'), // Add your app logo image here
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Welcome Text
                      const Text(
                        'Welcome to TECB Profiler',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // Login Button
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        onPressed: () {
                          // Handle login button press
                          print("Login button pressed");
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Signup Button
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        onPressed: () {
                          // Handle signup button press
                          print("Signup button pressed");
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Forgot Password Link
                      GestureDetector(
                        onTap: () {
                          // Handle forgot password action
                          print('Forgot Password tapped');
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
