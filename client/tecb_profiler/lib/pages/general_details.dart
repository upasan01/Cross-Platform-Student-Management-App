import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/date_picker.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/image_picker.dart';
import 'package:tecb_profiler/student_data_model.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';

class StudentGeneralDetails extends StatefulWidget {
  final StudentData? studentData;
  const StudentGeneralDetails({super.key, required this.studentData});

  @override
  State<StudentGeneralDetails> createState() => _StudentGeneralDetailsState();
}

class _StudentGeneralDetailsState extends State<StudentGeneralDetails> {
  // Controllers
  final studentNameController = TextEditingController();
  final universityRollController = TextEditingController();
  final registrationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final religionController = TextEditingController();
  final motherTongueController = TextEditingController();
  final permAddressController = TextEditingController();
  final permCityController = TextEditingController();
  final permPinCodeController = TextEditingController();
  final resCityController = TextEditingController();
  final resAddressController = TextEditingController();
  final resPinCodeController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final yearOfGraduationController = TextEditingController();
  final permStateController = TextEditingController();
  final permDistrictController = TextEditingController();
  final resStateController = TextEditingController();
  final resDistrictController = TextEditingController();

  // Dropdown options
  final types = ['Regular', 'Lateral'];
  final genders = ['Male', 'Female', 'Prefer Not To Say'];
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final categories = ['General', 'OBC', 'SC', 'ST'];
  final states = ['State 1', 'State 2'];

  // Dropdown selected values
  String? selectedType;
  String? selectedGender;
  String? selectedBloodGroup;
  String? selectedCategory;
  String? selectedPermState;
  String? selectedResState;
  DateTime? selectedDob;
  String? selectedImagePath;

  bool sameAsPermanent = false;

  // Global Keys For Validation
  //-----For Forms-----
  final studentNameFieldKey = GlobalKey<CustomFormFieldState>();
  final yearOfGradFieldKey = GlobalKey<CustomFormFieldState>();
  final phoneFieldKey = GlobalKey<CustomFormFieldState>();
  final emailFieldKey = GlobalKey<CustomFormFieldState>();
  final permAddressFieldKey = GlobalKey<CustomFormFieldState>();
  final permCityFieldKey = GlobalKey<CustomFormFieldState>();
  final permDistrictFieldKey = GlobalKey<CustomFormFieldState>();
  final permPinFieldKey = GlobalKey<CustomFormFieldState>();
  final resAddressFieldKey = GlobalKey<CustomFormFieldState>();
  final resCityFieldKey = GlobalKey<CustomFormFieldState>();
  final resDistrictFieldKey = GlobalKey<CustomFormFieldState>();
  final resPinFieldKey = GlobalKey<CustomFormFieldState>();

  //----For Drop Downs----
  final genderFieldKey = GlobalKey<CustomDropDownState>();
  final bloodGroupFieldKey = GlobalKey<CustomDropDownState>();
  final categoryFieldKey = GlobalKey<CustomDropDownState>();
  final permStateFieldKey = GlobalKey<CustomDropDownState>();
  final resStateFieldKey = GlobalKey<CustomDropDownState>();

  

  

@override
void initState() {
  super.initState();
  final data = widget.studentData;
  if (data != null) {
    studentNameController.text = data.fullName;
    universityRollController.text = data.uniRollNumber;
    registrationController.text = data.regNumber;
    yearOfGraduationController.text = data.session;
    phoneController.text = data.phoneNumber;
    emailController.text = data.email;
    selectedDob = data.dob;
    selectedGender = data.gender;
    selectedBloodGroup = data.bloodGroup;
    religionController.text = data.religion;
    selectedCategory = data.category;
    motherTongueController.text = data.motherTounge;
    selectedType = data.type;
    selectedImagePath = data.imagePath;

    // Permanent Address
    permAddressController.text = data.permanentAddress.fullAddress;
    permCityController.text = data.permanentAddress.city;
    selectedPermState = data.permanentAddress.state;
    permDistrictController.text = data.permanentAddress.district;
    permPinCodeController.text = data.permanentAddress.pin;

    // Residential Address
    resAddressController.text = data.residentialAddress.fullAddress;
    resCityController.text = data.residentialAddress.city;
    selectedResState = data.residentialAddress.state;
    resDistrictController.text = data.residentialAddress.district;
    resPinCodeController.text = data.residentialAddress.pin;

    heightController.text = data.height;
    weightController.text = data.weight ;
  }
}

void _saveData() {
  if (widget.studentData == null) return;

  widget.studentData!
    ..imagePath = selectedImagePath
    ..type = selectedType ?? ''
    ..fullName = studentNameController.text
    ..uniRollNumber = universityRollController.text
    ..regNumber = registrationController.text
    ..session = yearOfGraduationController.text
    ..phoneNumber = phoneController.text
    ..email = emailController.text
    ..dob = selectedDob
    ..gender = selectedGender ?? ''
    ..bloodGroup = selectedBloodGroup ?? ''
    ..religion = religionController.text
    ..category = selectedCategory ?? ''
    ..motherTounge = motherTongueController.text
    ..height = heightController.text
    ..weight = weightController.text
    ..permanentAddress = Address(
      fullAddress: permAddressController.text,
      city: permCityController.text,
      state: selectedPermState ?? '',
      district: permDistrictController.text,
      pin: permPinCodeController.text,
    )
    ..residentialAddress = Address(
      fullAddress: resAddressController.text,
      city: resCityController.text,
      state: selectedResState ?? '',
      district: resDistrictController.text,
      pin: resPinCodeController.text,
    );
}

void _handleNext(){
  final allFormFieldsValid = [
    studentNameFieldKey,
    yearOfGradFieldKey,
    phoneFieldKey,
    emailFieldKey,
    permAddressFieldKey,
    permCityFieldKey,
    permDistrictFieldKey,
    permPinFieldKey,
    resAddressFieldKey,
    resCityFieldKey,
    resDistrictFieldKey,
    resPinFieldKey
  ].every((key) => key.currentState?.validate() ?? false);

  final allDropDownsValid = [
    genderFieldKey,
    bloodGroupFieldKey,
    categoryFieldKey,
    permStateFieldKey,
    resStateFieldKey,
  ].every((key) => key.currentState?.validate() ?? false);

  print(allDropDownsValid);

    if (!allFormFieldsValid || !allDropDownsValid) {
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
      _saveData();
      // TODO: Navigate to next page when ready
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
        middle: Text('Student General Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomImagePicker(
                  onImagePicked: (imagePath) {
                    setState(() {
                      selectedImagePath = imagePath;
                    });
                  },
                ),
              ),
              CustomDropDown(
                label: 'Type',
                options: types,
                selectedValue: selectedType,
                required: true,
                onTap: (value) => setState(() => selectedType = value),
              ),
              CustomFormField(
                key: studentNameFieldKey,
                label: 'Student Name',
                controller: studentNameController,
                required: true,
              ),
              CustomFormField(
                label: 'University Roll Number',
                controller: universityRollController,
              ),
              CustomFormField(
                label: 'Registration Number',
                controller: registrationController,
              ),
              CustomFormField(
                key: yearOfGradFieldKey,
                label: 'Year of Graduation',
                controller: yearOfGraduationController,
                required: true,
              ),
              CustomFormField(
                key: phoneFieldKey,
                label: 'Student Phone Number',
                controller: phoneController,
                required: true,
              ),
              CustomFormField(
                key: emailFieldKey,
                label: 'Student Email ID',
                controller: emailController,
                required: true,
              ),
              CustomDatePicker(
                label: 'Date of Birth',
                selectedDate: selectedDob,
                required: true,
                onTap: (date) => setState(() => selectedDob = date),
              ),
              CustomDropDown(
                key: genderFieldKey,
                label: 'Gender',
                options: genders,
                selectedValue: selectedGender,
                required: true,
                onTap: (value) => setState(() => selectedGender = value),
              ),
              CustomDropDown(
                key: bloodGroupFieldKey,
                label: 'Blood Group',
                options: bloodGroups,
                selectedValue: selectedBloodGroup,
                required: true,
                onTap: (value) => setState(() => selectedBloodGroup = value),
              ),
              CustomFormField(
                label: 'Religion',
                controller: religionController,
              ),
              CustomDropDown(
                key: categoryFieldKey,
                label: 'Category',
                options: categories,
                selectedValue: selectedCategory,
                required: true,
                onTap: (value) => setState(() => selectedCategory = value),
              ),
              CustomFormField(
                label: 'Mother Tongue',
                controller: motherTongueController,
              ),

              const SizedBox(height: 20),
              const Text('Permanent Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomFormField(
                key: permAddressFieldKey,
                label: 'Address',
                controller: permAddressController,
                required: true,
              ),
              CustomFormField(
                key: permCityFieldKey,
                label: 'City',
                controller: permCityController,
                required: true,
              ),
              CustomDropDown(
                key: permStateFieldKey,
                label: 'State',
                options: states,
                selectedValue: selectedPermState,
                required: true,
                onTap: (value) => setState(() => selectedPermState = value),
              ),
              CustomFormField(
                key: permDistrictFieldKey,
                label: 'District',
                controller: permDistrictController,
                required: true,
              ),
              CustomFormField(
                key: permPinFieldKey,
                label: 'Pin Code',
                controller: permPinCodeController,
                required: true,
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  CupertinoSwitch(
                    value: sameAsPermanent,
                    onChanged: (value) {
                      setState(() {
                        sameAsPermanent = value;
                        if (sameAsPermanent) {
                          // Copy Permanent Address to Residential Address
                          resAddressController.text = permAddressController.text;
                          resCityController.text = permCityController.text;
                          resDistrictController.text = permDistrictController.text;
                          resPinCodeController.text = permPinCodeController.text;
                          selectedResState = selectedPermState; // Set the state for Residential Address
                        } else {
                          // Clear Residential Address fields when switch is off
                          resAddressController.clear();
                          resCityController.clear();
                          resDistrictController.clear();
                          resPinCodeController.clear();
                          selectedResState = null; // Reset Residential Address state
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text('Residential same as permanent'),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Residential Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomFormField(
                key: resAddressFieldKey,
                label: 'Address',
                controller: resAddressController,
                required: true,
                enabled: !sameAsPermanent,
              ),
              CustomFormField(
                key: resCityFieldKey,
                label: 'City',
                controller: resCityController,
                required: true,
                enabled: !sameAsPermanent,
              ),
              CustomDropDown(
                key: resStateFieldKey,
                label: 'State',
                options: states,
                selectedValue: selectedResState,
                onTap: (value) => setState(() => selectedResState = value),
                required: true,
                enabled: !sameAsPermanent,
              ),
              CustomFormField(
                key: resDistrictFieldKey,
                label: 'District',
                controller: resDistrictController,
                required: true,
                enabled: !sameAsPermanent,
              ),
              CustomFormField(
                key: resPinFieldKey,
                label: 'Pin Code',
                controller: resPinCodeController,
                required: true,
                enabled: !sameAsPermanent,
              ),

              const SizedBox(height: 20),
              CustomFormField(
                label: 'Height',
                controller: heightController,
              ),
              CustomFormField(
                label: 'Weight',
                controller: weightController,
              ),
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
