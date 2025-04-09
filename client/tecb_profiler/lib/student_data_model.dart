class StudentData {
  String fullName;
  String fatherName;
  String motherName;
  String email;
  String phone;
  String? bloodGroup;
  String? gender;
  DateTime? dob;
  String? imageUrl;

  StudentData({
    this.fullName = '',
    this.fatherName = '',
    this.motherName = '',
    this.email = '',
    this.phone = '',
    this.bloodGroup,
    this.dob,
    this.imageUrl,
    this.gender
  });
}