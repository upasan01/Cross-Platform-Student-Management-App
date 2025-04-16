import 'package:flutter/cupertino.dart';
import 'package:tecb_profiler/components/drop_down.dart';
import 'package:tecb_profiler/components/form_field.dart';
import 'package:tecb_profiler/components/utils/error_dialouge.dart';
import 'package:tecb_profiler/services/location_service.dart';
import 'package:tecb_profiler/student_data_model.dart';

class ParentGuardianDetailsPage extends StatefulWidget {
  final StudentData? studentData;
  const ParentGuardianDetailsPage({super.key, required this.studentData});

  @override
  State<ParentGuardianDetailsPage> createState() => _ParentGuardianDetailsPageState();
}

class _ParentGuardianDetailsPageState extends State<ParentGuardianDetailsPage> {
  // Controllers for Father's Details
  final fatherNameController = TextEditingController();
  final fatherPhoneController = TextEditingController();

  // Controllers for Mother's Details
  final motherNameController = TextEditingController();
  final motherPhoneController = TextEditingController();

  // Controllers for Local Guardian
  final localGuardianNameController = TextEditingController();
  final localGuardianAddressController = TextEditingController();
  final localGuardianCityController = TextEditingController();
  final localGuardianPinCodeController = TextEditingController();

  // Dropdown Options
  final occupations = ['Engineer', 'Doctor', 'Teacher', 'Business', 'Other'];
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

      // Mother
      motherNameController.text = data.mother.name;
      selectedMotherOccupation = data.mother.occupation;
      motherPhoneController.text = data.mother.phone;
      selectedMotherIncome = data.mother.income;

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
      data.father.occupation = selectedFatherOccupation ?? '';
      data.father.phone = fatherPhoneController.text;
      data.father.income = selectedFatherIncome;

      // Mother
      data.mother.name = motherNameController.text;
      data.mother.occupation = selectedMotherOccupation!;
      data.mother.phone = motherPhoneController.text;
      data.mother.income = selectedMotherIncome;

      // Guardian
      data.hasLocalGuardian = hasLocalGuardian;
      if (hasLocalGuardian) {
        data.localGuardian?.name = localGuardianNameController.text;
        data.localGuardian?.occupation = selectedGuardianOccupation!;
        data.localGuardian?.address?.fullAddress = localGuardianAddressController.text;
        data.localGuardian?.address?.city = localGuardianCityController.text;
        data.localGuardian?.address?.state = selectedGuardianState;
        data.localGuardian?.address?.district = selectedGuardianDistrict;
        data.localGuardian?.address?.pin = localGuardianPinCodeController.text;
      } else {
        data.localGuardian = null;
      }
    }
  }

void _handleNext() {
  _saveData();
  widget.studentData?.printStudentData();
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

              const SizedBox(height: 20),
              const Text('Mother\'s Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomFormField(
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
                  label: "Local Guardian Name",
                  controller: localGuardianNameController,
                ),
                CustomDropDown(
                  label: "Local Guardian Occupation",
                  options: occupations,
                  selectedValue: selectedGuardianOccupation,
                  onTap: (val) => setState(() => selectedGuardianOccupation = val),
                ),
                CustomFormField(
                  label: "Address",
                  controller: localGuardianAddressController,
                ),
                CustomFormField(
                  label: "City",
                  controller: localGuardianCityController,
                ),
                CustomDropDown(
                  label: "State",
                  options: states,
                  selectedValue: selectedGuardianState,
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
                  label: "District",
                  options: guardianDistricts,
                  selectedValue: selectedGuardianDistrict,
                  onTap: (value) {
                    setState(() {
                      selectedGuardianDistrict = value;
                    });
                  },
                ),
                CustomFormField(
                  label: "Pin Code",
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
