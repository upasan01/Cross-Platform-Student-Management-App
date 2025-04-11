class StudentData {
  String fullName;
  String fatherName;
  String motherName;
  String email;
  int?phone;
  String? bloodGroup;
  String? gender;
  DateTime? dob;
  String? imagePath;
  int?roll;
  int?regNo;
  String?course;
  String yOfGraduation;
  String boardOfEducation;
  double?result; 
  String schoolName;
  String address;

  StudentData({
    this.fullName = '',
    this.fatherName = '',
    this.motherName = '',
    this.email = '',
    this.phone ,
    this.address = '',
    this.bloodGroup,
    this.dob,
    this.imagePath,
    this.gender,
    this.course = '',
    this.roll,
    this.regNo,
    this.yOfGraduation = '',
    this.result,
    this.boardOfEducation = '',
    this.schoolName = '',
  }); 

  void printStudentData() {
    print('Full Name: $fullName');
    print('Father\'s Name: $fatherName');
    print('Mother\'s Name: $motherName');
    print('Email: $email');
    print('Phone: ${phone ?? 'N/A'}');
    print('Blood Group: ${bloodGroup ?? 'N/A'}');
    print('Gender: ${gender ?? 'N/A'}');
    print('Date of Birth: ${dob != null ? dob.toString().split(' ')[0] : 'N/A'}');
    print('Image URL: ${imagePath ?? 'N/A'}');
    print('Roll Number: ${roll ?? 'N/A'}');
    print('Registration Number: ${regNo ?? 'N/A'}');
    print('Course: $course');
    print('Year of Graduation: $yOfGraduation');
    print('Board of Education: $boardOfEducation');
    print('Result: ${result ?? 'N/A'}');
    print('School Name: $schoolName');
  }

  
}