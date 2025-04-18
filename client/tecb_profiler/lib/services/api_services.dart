import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tecb_profiler/student_data_model.dart';

class ServerApiService {
  static Future<http.Response> sendSignUpRequest({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://localhost:3000/api/v1/user/signup');

    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    return response;
  }

  static Future<http.Response> sendLoginRequest({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://localhost:3000/api/v1/user/signin');

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    return response;
  }

  static Future<http.StreamedResponse> uploadImage({
    required StudentData studentData,
    required String token,
  }) async {
    final String apiUrl = 'http://localhost:3000/api/v1/student/uploadImage';

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['token'] = token;

    var file = await _getMultipartFile(studentData.imagePath!);
    request.files.add(file);

    var response = await request.send();
    return response;
  }

  static Future<http.MultipartFile> _getMultipartFile(String imagePath) async {
    String fileExtension = imagePath.split('.').last.toLowerCase();

    MediaType mediaType;

    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
        mediaType = MediaType('image', 'jpeg');
        break;
      case 'png':
        mediaType = MediaType('image', 'png');
        break;
      default:
        mediaType = MediaType('image', 'jpeg');
    }

    return await http.MultipartFile.fromPath(
      'image',
      imagePath,
      contentType: mediaType,
    );
  }

  static Future<http.Response> sendStudentInfo({
    required StudentData data,
    required String token,
  }) async {
    try {
      final url = Uri.parse('http://localhost:3000/api/v1/student/infoEntry');
      final Map<String, dynamic> requestBody = {
        "studentDetails": {
          "type": data.type,
          "fullName": data.fullName,
          "uniRollNumber": int.tryParse(data.uniRollNumber),
          "regNumber": int.tryParse(data.regNumber),
          "session": data.session,
          "phoneNumber": int.tryParse(data.phoneNumber),
          "email": data.email,
          "aadhaarNumber": int.tryParse(data.studentAadhaar),
          "panNumber": data.studentPAN,
          "dob": data.dob!.toIso8601String(),
          "gender": data.gender,
          "bloodGroup": data.bloodGroup,
          "religion": data.religion,
          "category": data.category,
          "motherTounge": data.motherTounge,
          "height": data.height,
          "weight": data.weight,
          "permanentAddress": {
            "fullAddress": data.permanentAddress.fullAddress,
            "city": data.permanentAddress.city,
            "state": data.permanentAddress.state,
            "district": data.permanentAddress.district,
            "pin": int.tryParse(data.permanentAddress.pin)
          },
          "residentialAddress": {
            "fullAddress": data.residentialAddress.fullAddress,
            "city": data.residentialAddress.city,
            "state": data.residentialAddress.state,
            "district": data.residentialAddress.district,
            "pin": int.tryParse(data.residentialAddress.pin)
          }
        },
        "parentsDetails": {
          "father": {
            "fullName": data.father.name,
            "occupation": data.father.occupation ?? '',
            "phone": int.tryParse(data.father.phone),
            "income": data.father.income ?? '',
            "aadhaarNumber": int.tryParse(data.father.aadhaar),
            "panNumber": data.father.pan,
          },
          "mother": {
            "fullName": data.mother.name,
            "occupation": data.mother.occupation ?? '',
            "phone": int.tryParse(data.mother.phone),
            "income": data.mother.income ?? '',
            "aadhaarNumber": int.tryParse(data.mother.aadhaar),
            "panNumber": data.mother.pan,
          },
          "localGuardian": {
            "fullName": data.localGuardian?.name ?? '',
            "occupation": data.localGuardian?.occupation ?? '',
            "address": {
              "fullAddress": data.localGuardian?.address?.fullAddress ?? '',
              "city": data.localGuardian?.address?.city ?? '',
              "state": data.localGuardian?.address?.state ?? '',
              "district": data.localGuardian?.address?.district ?? '',
              "pin": int.tryParse(data.localGuardian?.address?.pin ?? '')
            }
          }
        },
        "educationalDetails": {
          "hs": {
            "percentage": double.tryParse(data.academic.hsPercentage),
            "board": data.academic.hsBoard,
            "year": int.tryParse(data.academic.hsPassingYear),
            "school": data.academic.hsSchoolName
          },
          "secondary": {
            "percentage": double.tryParse(data.academic.secondaryPercentage),
            "board": data.academic.secondaryBoard,
            "year": int.tryParse(data.academic.secondaryPassingYear),
            "school": data.academic.secondarySchoolName
          },
          "diploma": {
            "cgpa": double.tryParse(data.academic.diplomaCGPA),
            "college": data.academic.diplomaCollege,
            "stream": data.academic.diplomaStream,
            "year": int.tryParse(data.academic.diplomaPassingYear)
          }
        },
        "extraDetails": {
          "hobbies": data.extraCurricular?.hobbies ?? '',
          "interestedDomain": data.extraCurricular?.interestedDomain ?? '',
          "bestSubject": data.extraCurricular?.subjectBest ?? '',
          "leastSubject": data.extraCurricular?.subjectLeast ?? ''
        }
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: jsonEncode(requestBody),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
