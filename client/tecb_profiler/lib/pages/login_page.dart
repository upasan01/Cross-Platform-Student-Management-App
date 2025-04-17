import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/pages/general_details.dart';
import 'package:tecb_profiler/services/api_services.dart';
import 'package:tecb_profiler/pages/signup_page.dart';
import 'package:tecb_profiler/services/jwt_actions.dart';
import 'package:tecb_profiler/student_data_model.dart'; // Import SignUpPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFieldKey = GlobalKey<CustomFormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();

  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    final allValid = emailFieldKey.currentState?.validate() ?? false;

    if (!allValid || passwordController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Missing Fields"),
          content: const Text("Please enter both email and password."),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final response = await ServerApiService.sendLoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if(!mounted) return;
            
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        await TokenStorage.saveToken(token);

        if(!mounted) return;

        // Create a new StudentFormData object when the user starts the form
        final studentData =  StudentData(
          permanentAddress: Address(), 
          residentialAddress: Address(), 
          father: Parent(address: Address()),
          mother: Parent(address: Address()),
          academic: AcademicDetails()
        );

        Navigator.push(
          context, 
          CupertinoPageRoute(builder: (context)=> StudentGeneralDetails(studentData: studentData)));
      }else {
          ErrorDialogUtility.showErrorDialog(
            context,
            errorMessage: "Login failed. Please check your credentials.",
        );}


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
        middle: Text('Login'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomFormField(
                      key: emailFieldKey,
                      label: 'Email',
                      controller: emailController,
                      required: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      key: passwordFieldKey,
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      placeholder: 'Password',
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      style: const TextStyle(fontSize: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.inactiveGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Text(
                          _isPasswordVisible ? 'Hide' : 'Show',
                          style: const TextStyle(color: CupertinoColors.activeBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton.filled(
                      onPressed: _handleLogin,
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text(
                  "Don't have an account?",
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
