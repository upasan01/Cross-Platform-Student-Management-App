import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/pages/login_page.dart';
import 'package:tecb_profiler/services/api_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // GlobalKeys for validating CustomFormFields
  final firstNameFieldKey = GlobalKey<CustomFormFieldState>();
  final lastNameFieldKey = GlobalKey<CustomFormFieldState>();
  final emailFieldKey = GlobalKey<CustomFormFieldState>();


  // Toggle for password visibility
  bool _isPasswordVisible = false;


  // Handle form submission
  Future<void> _handleSignUp() async {
    // Validate all required fields
    final allFormsValid = [
      firstNameFieldKey,
      lastNameFieldKey,
      emailFieldKey,
    ].every((key) => key.currentState?.validate() ?? false);

    if (!allFormsValid) {
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
      final response = await ApiService.sendSignUpRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text
      );

      if(!mounted) return;

      if(response.statusCode == 200){
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => LoginPage())
        );
      }else{
        ErrorDialogUtility.showErrorDialog(context, errorMessage: response.body.toString());
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
        middle: Text('Sign Up'),
      ),
      child: SafeArea(
        child: Center( // This centers the content vertically and horizontally
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // The text above the container
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20), // Vertical padding for spacing
                  child: Text(
                    'Get Signed Up Real Quick',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                ),
                // The container wrapping the form with reduced width
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40), // Reduced margin for smaller width
                  padding: const EdgeInsets.all(50), // Padding inside the container
                  height: 600,
                  width: 500, // Height of the container
                  decoration: BoxDecoration(
                    color: CupertinoColors.white, // Background color for the container
                    borderRadius: BorderRadius.circular(16), // Rounded corners for the container
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.inactiveGray.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: Offset(0, 4), // Shadow offset
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormField(
                          key: firstNameFieldKey,
                          label: 'First Name',
                          controller: firstNameController,
                          required: true,
                        ),
                        CustomFormField(
                          key: lastNameFieldKey,
                          label: 'Last Name',
                          controller: lastNameController,
                          required: true,
                        ),
                        CustomFormField(
                          key: emailFieldKey,
                          label: 'Email',
                          controller: emailController,
                          required: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        // CustomPasswordField instead of CustomFormField for password
                        CupertinoTextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible, // Toggle password visibility
                          placeholder: 'Password',
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          style: TextStyle(fontSize: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: CupertinoColors.inactiveGray),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Text(
                                _isPasswordVisible ? 'Hide' : 'Show',
                                style: TextStyle(
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: CupertinoButton.filled(
                            onPressed: _handleSignUp,
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Add the "Already have an Account?" text at the bottom
                Padding(
                  padding: const EdgeInsets.only(top: 20), // Padding above the text
                  child: GestureDetector(
                    onTap: () {
                      // Handle tap here (e.g., navigate to Login page)
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => LoginPage())
                      );
                    },
                    child: Text(
                      'Already have an Account?',
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
      ),
    );
  }
}
