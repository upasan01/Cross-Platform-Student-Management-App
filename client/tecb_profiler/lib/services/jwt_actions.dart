import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Save the token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Get the stored token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Delete the stored token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
