import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../services/services.dart';
import 'encryption.dart'; // قم باستيراد فئة التشفير هنا

class TokenService {
  final Services services = Get.find();
  final Encryption encryption = Encryption();

  Future<void> storeToken(String key, String token) async {
    final encryptedToken = await encryption.encryptData(token);
    await services.storage.write(key: key, value: encryptedToken);
  }

  Future<String?> getToken(String key) async {
    final encryptedToken = await services.storage.read(key: key);
    return encryptedToken != null ? await encryption.decryptData(encryptedToken) : null;
  }

  Future<void> refreshToken(String clientId, String clientSecret) async {
    final idToken = await getToken('idToken');
    if (idToken == null) return;

    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': idToken,
        'grant_type': 'refresh_token',
      },
    );

    if (response.statusCode == 200) {
      final newAccessToken = jsonDecode(response.body)['access_token'];
      if (newAccessToken != null) {
        await storeToken('accessToken', newAccessToken);
        print('Access token refreshed successfully.');
      }
    } else {
      print('Failed to refresh access token.');
    }
  }
}
