import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tecb_profiler/student_data_model.dart';
class ApiService {
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
  final url = Uri.parse('http://localhost:3000/api/v1/user/signin'); // Replace with your local IP or server URL

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
  static Future<http.StreamedResponse> sendFormData({
    required StudentData studentData,
    required String token
  }) async {
    final String apiUrl = 'http://localhost:3000/api/v1/student/infoEntry';

      // Prepare the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add text fields as form parameters
    request.headers['token'] = token;
    request.fields['fullName'] = studentData.fullName;
    request.fields['fathersName'] = studentData.fatherName;
    request.fields['mothersName'] = studentData.motherName;
    request.fields['email'] = studentData.email;
    request.fields['universityRoll'] = studentData.roll.toString();
    request.fields['registrationNumber'] = studentData.regNo.toString();
    request.fields['gender'] = studentData.gender.toString();
    request.fields['phone'] = studentData.phone.toString();
    request.fields['department'] = studentData.course.toString();
    request.fields['session'] = studentData.yOfGraduation;
    request.fields['boardOfEdu'] = studentData.boardOfEducation;
    request.fields['class12Marks'] = studentData.result.toString();
    request.fields['address'] = studentData.address;
    request.fields['schoolName'] = studentData.schoolName;
    request.fields['bloodGroup'] = studentData.bloodGroup.toString();
    request.fields['dob'] = studentData.dob!.toIso8601String(); // Date format in ISO8601

    // Add image as a file parameter
    var file = await _getMultipartFile(studentData.imagePath!);

    request.files.add(file);

    // Send the request
    var response = await request.send();

    return response;
    
  }

  static Future<http.MultipartFile> _getMultipartFile(String imagePath) async {
    String fileExtension = imagePath.split('.').last.toLowerCase(); // Get the file extension and convert to lowercase
    
    MediaType mediaType;
    
    // Map extensions to corresponding MediaType
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
        mediaType = MediaType('image', 'jpeg');
        break;
      case 'png':
        mediaType = MediaType('image', 'png');
        break;
      default:
        // Default to JPEG if the extension is unsupported (can be adjusted based on use case)
        mediaType = MediaType('image', 'jpeg');
    }

    // Return the image as a MultipartFile with the appropriate content type
    return await http.MultipartFile.fromPath(
      'image', // The field name for image in your backend
      imagePath, // Path to the image file
      contentType: mediaType, // Dynamically setting content type
    );
  }



}
