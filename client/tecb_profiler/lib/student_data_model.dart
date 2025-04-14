class StudentData {
  String? imagePath;

  // Student details
  String type; // Regular or Lateral
  String fullName;
  String uniRollNumber;
  String regNumber;
  String session; // Year of Graduation
  String phoneNumber;
  String email;
  DateTime? dob;
  String? gender;
  String? bloodGroup;
  String religion;
  String? category;
  String motherTounge;
  String height;
  String weight;

  // Permanent address
  Address permanentAddress;

  // Residential address
  Address residentialAddress;

  StudentData({
    this.imagePath = '',
    this.type = "Regular",
    this.fullName = '',
    this.uniRollNumber = '',
    this.regNumber = '',
    this.session = '',
    this.phoneNumber = '',
    this.email = '',
    this.dob,
    this.gender,
    this.bloodGroup,
    this.religion = '',
    this.category,
    this.motherTounge = '',
    this.height = '',
    this.weight = '',
    required this.permanentAddress,
    required this.residentialAddress,
  });

  void printStudentData() {
    print('Full Name: $fullName');
    print('Type: $type');
    print('University Roll Number: $uniRollNumber');
    print('Registration Number: $regNumber');
    print('Year of Graduation: $session');
    print('Phone Number: $phoneNumber');
    print('Email: $email');
    print('Date of Birth: $dob');
    print('Gender: $gender');
    print('Blood Group: $bloodGroup');
    print('Religion: $religion');
    print('Category: $category');
    print('Mother Tongue: $motherTounge');
    print('Height: $height');
    print('Weight: $weight');
    print('Permanent Address: ${permanentAddress.printAddress()}');
    print('Residential Address: ${residentialAddress.printAddress()}');
  }
}

class Address {
  String fullAddress;
  String city;
  String? state;
  String district;
  String pin;

  Address({
    this.fullAddress = '',
    this.city = '',
    this.state,
    this.district = '',
    this.pin = '',
  });

  String printAddress() {
    return '$fullAddress, $city, $state, $district, $pin';
  }
}
