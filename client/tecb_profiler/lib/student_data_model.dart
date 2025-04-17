class StudentData {
  String? imagePath;

  // Student details
  String type;
  String fullName;
  String uniRollNumber;
  String regNumber;
  String session;
  String phoneNumber;
  String email;
  DateTime? dob;
  String? gender;
  String? bloodGroup;
  String? category;
  String religion;
  String motherTounge;
  String studentAadhaar;
  String studentPAN;
  String height;
  String weight;

  // Permanent address
  Address permanentAddress;

  // Residential address
  Address residentialAddress;

  // Parent & Guardian details
  bool hasLocalGuardian;
  Parent father;
  Parent mother;
  Parent? localGuardian;

  // Academic Details
  AcademicDetails academic;

  // Extracurricular
  ExtraCurricularDetails? extraCurricular;


  StudentData({
    this.imagePath = '',
    this.type = "Regular",
    this.fullName = '',
    this.uniRollNumber = '',
    this.regNumber = '',
    this.session = '',
    this.phoneNumber = '',
    this.email = '',
    this.studentAadhaar  = '',
    this.studentPAN = '',
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
    required this.father,
    required this.mother,
    this.hasLocalGuardian = false,
    this.localGuardian,
    required this.academic,
    this.extraCurricular

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
    print('Father: ${father.printParent()}');
    print('Mother: ${mother.printParent()}');
    if (localGuardian != null) {
      print('Local Guardian: ${localGuardian!.printParent()}');
    }
    print('Academic Details: ${academic.printAcademicDetails()}');
    print('Extra Curricular Details: ${extraCurricular?.printExtraCurricularDetails()}');


  }
}

class Address {
  String fullAddress;
  String city;
  String? state;
  String?district;
  String pin;

  Address({
    this.fullAddress = '',
    this.city = '',
    this.state,
    this.district,
    this.pin = '',

  });

  String printAddress() {
    return '$fullAddress, $city, $state, $district, $pin';
  }
}

class Parent {
  String name;
  String phone;
  String?occupation;
  String?income;
  Address?address;
  String aadhaar;
  String pan;

  

  Parent({
    this.name = '',
    this.occupation ,
    this.phone = '',
    this.income,
    this.address,
    this.aadhaar = '',
    this.pan = '',
  });

  String printParent() {
    return 'Name: $name, Occupation: $occupation, Phone: $phone, Income: $income, Address: ${address?.printAddress()}';
  }
}


class AcademicDetails {
  // Higher Secondary (for Regular)
  String hsPercentage;
  String hsBoard;
  String hsPassingYear;
  String hsSchoolName;

  // Secondary (for all)
  String secondaryPercentage;
  String secondaryBoard;
  String secondaryPassingYear;
  String secondarySchoolName;

  // Diploma (for Lateral)
  String diplomaCGPA;
  String diplomaCollege;
  String diplomaStream;
  String diplomaPassingYear;

  AcademicDetails({
    this.hsPercentage = '',
    this.hsBoard = '',
    this.hsPassingYear = '',
    this.hsSchoolName = '',
    this.secondaryPercentage = '',
    this.secondaryBoard = '',
    this.secondaryPassingYear = '',
    this.secondarySchoolName = '',
    this.diplomaCGPA = '',
    this.diplomaCollege = '',
    this.diplomaStream = '',
    this.diplomaPassingYear = '',
  });

  String printAcademicDetails() {
    return '''
    HS %: $hsPercentage, Board: $hsBoard, Year: $hsPassingYear, School: $hsSchoolName
    Secondary %: $secondaryPercentage, Board: $secondaryBoard, Year: $secondaryPassingYear, School: $secondarySchoolName
    Diploma CGPA: $diplomaCGPA, College: $diplomaCollege, Stream: $diplomaStream, Year: $diplomaPassingYear
    ''';
  }
}

class ExtraCurricularDetails {
  String hobbies;
  String interestedDomain;
  String subjectBest;
  String subjectLeast;

  ExtraCurricularDetails({
    this.hobbies = '',
    this.interestedDomain = '',
    this.subjectBest = '',
    this.subjectLeast = '',
  });

  String printExtraCurricularDetails() {
    return '''
    Hobbies: $hobbies
    Interested Domain: $interestedDomain
    Best Subject: $subjectBest
    Least Subject: $subjectLeast
    ''';
  }
}

 