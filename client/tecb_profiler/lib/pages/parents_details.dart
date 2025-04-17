import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/components/utils/validiation_dialog.dart';
import 'package:tecb_profiler/pages/academics_details.dart';
import 'package:tecb_profiler/services/location_service.dart';
import 'package:tecb_profiler/student_data_model.dart';

class ParentGuardianDetailsPage extends StatefulWidget {
  final StudentData? studentData;
  const ParentGuardianDetailsPage({super.key, required this.studentData});

  @override
  State<ParentGuardianDetailsPage> createState() => _ParentGuardianDetailsPageState();
}

class _ParentGuardianDetailsPageState extends State<ParentGuardianDetailsPage> {

  // Global Keys
  final fatherNameFieldKey = GlobalKey<CustomFormFieldState>();
  final motherNameFieldKey = GlobalKey<CustomFormFieldState>();
  final lgNameFieldKey = GlobalKey<CustomFormFieldState>();
  final lgAddressFieldKey = GlobalKey<CustomFormFieldState>();
  final lgCityFieldKey = GlobalKey<CustomFormFieldState>();
  final lgPinFieldKey = GlobalKey<CustomFormFieldState>();
  final lgStateFieldKey = GlobalKey<CustomDropDownState>();
  final lgDistrictFieldKey = GlobalKey<CustomDropDownState>();
  

  // Controllers for Father's Details
  final fatherNameController = TextEditingController();
  final fatherPhoneController = TextEditingController();
  final fatherAadhaarController = TextEditingController();
  final fatherPanController = TextEditingController();

  // Controllers for Mother's Details
  final motherNameController = TextEditingController();
  final motherPhoneController = TextEditingController();
  final motherAadhaarController = TextEditingController();
  final motherPanController = TextEditingController();

  // Controllers for Local Guardian
  final localGuardianNameController = TextEditingController();
  final localGuardianAddressController = TextEditingController();
  final localGuardianCityController = TextEditingController();
  final localGuardianPinCodeController = TextEditingController();

  // Dropdown Options
  final occupations = ['Service', 'Business', 'Self Employed'];
  final incomeRanges = ['< 1 Lakh', '1-3 Lakhs', '3-5 Lakhs', '5-10 Lakhs', '> 10 Lakhs'];
  List<String> states = [];
  List<String> guardianDistricts = [];

  // Selected Dropdown Values
  String? selectedFatherOccupation;
  String? selectedFatherIncome;
  String? selectedMotherOccupation;
  String? selectedMotherIncome;
  String? selectedGuardianOccupation;
  String? selectedGuardianState;
  String? selectedGuardianDistrict;

  bool hasLocalGuardian = false;

  void _asyncLoadState() async {
  final allState = await LocationService.loadStates();
  setState(() {
    states = allState;
  });
}

  @override
  void initState() {
    super.initState();
    _asyncLoadState();
    final data = widget.studentData;

    if (data != null) {
      // Father
      fatherNameController.text = data.father.name;
      selectedFatherOccupation = data.father.occupation;
      fatherPhoneController.text = data.father.phone;
      selectedFatherIncome = data.father.income;
      fatherAadhaarController.text = data.father.aadhaar;
      fatherPanController.text = data.father.pan;

      // Mother
      motherNameController.text = data.mother.name;
      selectedMotherOccupation = data.mother.occupation;
      motherPhoneController.text = data.mother.phone;
      selectedMotherIncome = data.mother.income;
      motherAadhaarController.text = data.mother.aadhaar;
      motherPanController.text = data.mother.pan;

      // Guardian (if applicable)
      hasLocalGuardian = data.hasLocalGuardian == true;

      if (hasLocalGuardian) {
        localGuardianNameController.text = data.localGuardian!.name;
        selectedGuardianOccupation = data.localGuardian!.occupation;
        localGuardianAddressController.text = data.localGuardian!.address!.fullAddress;
        localGuardianCityController.text = data.localGuardian!.address!.city;
        selectedGuardianState = data.localGuardian!.address!.state;
        selectedGuardianDistrict = data.localGuardian!.address!.district;
        localGuardianPinCodeController.text = data.localGuardian!.address!.pin;
      }
    }
}

  void _saveData() {
    final data = widget.studentData;

    if (data != null) {
      // Father
      data.father.name = fatherNameController.text;
      data.father.occupation = selectedFatherOccupation;
      data.father.phone = fatherPhoneController.text;
      data.father.income = selectedFatherIncome;
      data.father.aadhaar = fatherAadhaarController.text;
      data.father.pan = fatherPanController.text;

      // Mother
      data.mother.name = motherNameController.text;
      data.mother.occupation = selectedMotherOccupation;
      data.mother.phone = motherPhoneController.text;
      data.mother.income = selectedMotherIncome;
      data.mother.aadhaar = motherAadhaarController.text;
      data.mother.pan = motherPanController.text;

      // Guardian
      data.hasLocalGuardian = hasLocalGuardian;
      if (hasLocalGuardian) {
        data.localGuardian = Parent(
          name: localGuardianNameController.text,
          occupation: selectedGuardianOccupation,
          address: Address(
            fullAddress: localGuardianAddressController.text.trim(),
            city: localGuardianCityController.text.trim(),
            state: selectedGuardianState,
            district: selectedGuardianDistrict,
            pin: localGuardianPinCodeController.text.trim()
          )
        );
      }
    }
  }

void _handleNext() {
  final fatherPhone = fatherPhoneController.text.trim();
  final motherPhone = motherPhoneController.text.trim();
  final studentPhone = widget.studentData!.phoneNumber.trim();
  bool isSame = (fatherPhone == motherPhone) || (motherPhone == studentPhone) || (fatherPhone == studentPhone);

  // Validation: At least one must be provided
  if (fatherPhone.isEmpty && motherPhone.isEmpty) {
    ErrorDialogUtility.showErrorDialog( 
      context,
      errorMessage: "Please provide at least one phone number: Father's or Mother's.",
    );
    return;
  }

  if (isSame) {
    ErrorDialogUtility.showErrorDialog(
      context,
      errorMessage: "Cannot Have same phone number for Father, Mother or Student",
    );
    return;
  }
  List<GlobalKey<CustomFormFieldState>> allFormFieldKeys = [
    fatherNameFieldKey,
    motherNameFieldKey,
  ];

  List<GlobalKey<CustomDropDownState>> allDropDownKeys = [];
  if (hasLocalGuardian) {
    allFormFieldKeys.addAll(
      [
        lgNameFieldKey,
        lgAddressFieldKey,
        lgCityFieldKey,
        lgPinFieldKey,
      ]
    );

    allDropDownKeys.addAll([
      lgStateFieldKey,
      lgDistrictFieldKey
    ]);
  }

  final allFormFieldsValid = allFormFieldKeys.every((key) => key.currentState?.validate() ?? false);

  final allDropDownsValid = allDropDownKeys.every((key) => key.currentState?.validate() ?? false);

  if (!allFormFieldsValid || !allDropDownsValid) {
    ValidationDialog.show(context: context);
    return;
  }
  _saveData();
  Navigator.push(
    context,
    CupertinoPageRoute(builder: (context) => StudentAcademicDetailsPage(studentData: widget.studentData))
    );
  // Navigate to next page or perform further validation/logic
}

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Parent & Guardian Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Father\'s Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomFormField(
                key: fatherNameFieldKey,
                label: "Father's Name",
                controller: fatherNameController,
                required: true,
              ),
              CustomDropDown(
                label: "Father's Occupation",
                options: occupations,
                selectedValue: selectedFatherOccupation,
                onTap: (val) => setState(() => selectedFatherOccupation = val),
              ),
              CustomFormField(
                label: "Phone Number",
                controller: fatherPhoneController,
                required: true,
              ),
              CustomDropDown(
                label: "Annual Income",
                options: incomeRanges,
                selectedValue: selectedFatherIncome,
                onTap: (val) => setState(() => selectedFatherIncome = val),
              ),

              CustomFormField(
                // key: studentAadhaarFieldKey,
                label: 'Aadhaar Number',
                controller: fatherAadhaarController,
              ),
              
              CustomFormField(
                // key: studentPanFieldKey,
                label: 'PAN',
                controller: fatherPanController,
              ),

              const SizedBox(height: 20),
              const Text('Mother\'s Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomFormField(
                key: motherNameFieldKey,
                label: "Mother's Name",
                controller: motherNameController,
                required: true,
              ),
              CustomDropDown(
                label: "Mother's Occupation",
                options: occupations,
                selectedValue: selectedMotherOccupation,
                onTap: (val) => setState(() => selectedMotherOccupation = val),
              ),
              CustomFormField(
                label: "Phone Number",
                controller: motherPhoneController,
                required: true,
              ),
              CustomDropDown(
                label: "Annual Income",
                options: incomeRanges,
                selectedValue: selectedMotherIncome,
                onTap: (val) => setState(() {
                  selectedMotherIncome = val;
                }),
              ),
              CustomFormField(
                // key: studentAadhaarFieldKey,
                label: 'Aadhaar Number',
                controller: motherAadhaarController,
              ),
              
              CustomFormField(
                // key: studentPanFieldKey,
                label: 'PAN',
                controller: motherPanController,
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  CupertinoSwitch(
                    value: hasLocalGuardian,
                    onChanged: (val) {
                      localGuardianNameController.clear();
                      localGuardianAddressController.clear();
                      localGuardianCityController.clear();
                      selectedGuardianOccupation = null;
                      selectedGuardianDistrict = null;
                      selectedGuardianState = null;
                      setState(() => hasLocalGuardian = val);

                      },
                  ),
                  const SizedBox(width: 8),
                  const Text('Have a different local guardian?'),
                ],
              ),

              if (hasLocalGuardian) ...[
                const SizedBox(height: 10),
                const Text('Local Guardian Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                CustomFormField(
                  key: lgNameFieldKey,
                  label: "Local Guardian Name",
                  controller: localGuardianNameController,
                  required: hasLocalGuardian,
                ),
                CustomDropDown(
                  label: "Local Guardian Occupation",
                  options: occupations,
                  selectedValue: selectedGuardianOccupation,
                  onTap: (val) => setState(() => selectedGuardianOccupation = val),
                ),
                CustomFormField(
                  key: lgAddressFieldKey,
                  label: "Address",
                  controller: localGuardianAddressController,
                  required: hasLocalGuardian,
                ),
                CustomFormField(
                  key: lgCityFieldKey,
                  label: "City",
                  controller: localGuardianCityController,
                  required: hasLocalGuardian,
                ),
                CustomDropDown(
                  key: lgStateFieldKey,
                  label: "State",
                  options: states,
                  selectedValue: selectedGuardianState,
                  required: hasLocalGuardian,
                  onTap: (value) async  {
                    setState(() {
                      selectedGuardianState = value;
                      selectedGuardianDistrict = null;
                      guardianDistricts = [];
                    });
                    final districts = await LocationService.updateDistricts(value);
                    setState(() => guardianDistricts = districts);
                  },
                ),
                CustomDropDown(
                  key: lgDistrictFieldKey,
                  label: "District",
                  options: guardianDistricts,
                  selectedValue: selectedGuardianDistrict,
                  required: hasLocalGuardian,
                  onTap: (value) {
                    setState(() {
                      selectedGuardianDistrict = value;
                    });
                  },
                ),
                CustomFormField(
                  key: lgPinFieldKey,
                  label: "Pin Code",
                  required: hasLocalGuardian,
                  controller: localGuardianPinCodeController,
                ),
              ],
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
