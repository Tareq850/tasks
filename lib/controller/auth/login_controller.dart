import 'dart:convert';

import 'package:assessment/core/packages/encryption.dart';
import 'package:assessment/core/packages/statusrequest.dart';
import 'package:assessment/core/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import '../../core/functions/handle_data.dart';
import '../../data/datasource/auth_data.dart';
import 'package:http/http.dart' as http;

abstract class LoginController extends GetxController {
  goToRegister();
}

class LoginControllerImp extends LoginController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '709774881962-rjiiohnb2nfd8qtqijv1j45edc1gg0i3.apps.googleusercontent.com', // تعيين Client ID هنا
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  var user = Rxn<GoogleSignInAccount>();

  Encryption encryption = Encryption();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  StatusRequest statusRequest = StatusRequest.none;
  AuthData authData = AuthData(Get.find());
  var isLoggedIn = false.obs;
  late oauth2.AuthorizationCodeGrant grant;
  Services services = Get.find();
  final String clientId =
      '709774881962-rjiiohnb2nfd8qtqijv1j45edc1gg0i3.apps.googleusercontent.com';
  @override
  void onInit() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      user.value = account;
    });
    _googleSignIn
        .signInSilently();
    if (user.value != null) {
      refreshGoogleToken();
    }
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken != null && idToken != null) {
        await storeGoogleTokens(accessToken, idToken);
        user.value = googleUser;
        Get.offAllNamed("/home");
      }} catch (e) {
      print("Error during Google login: $e");
      Get.defaultDialog(
        title: "Login Error",
        content: Text("An error occurred during Google login: $e"),
      );}}
  Future<void> storeGoogleTokens(String accessToken, String idToken) async {
    String encryptedAccessToken = await encryption.encryptData(accessToken);
    String encryptedIdToken = await encryption.encryptData(idToken);

    await services.storage.write(key: 'googleAccessToken', value: encryptedAccessToken);
    await services.storage.write(key: 'googleIdToken', value: encryptedIdToken);
  }

  Future<void> refreshGoogleToken() async {
    final encryptedIdToken = await services.storage.read(key: 'googleIdToken');
    if (encryptedIdToken == null) {
      print('No Google refresh token available.');
      return;
    }
    String idToken = await encryption.decryptData(encryptedIdToken);
    try {
      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': '709774881962-rjiiohnb2nfd8qtqijv1j45edc1gg0i3.apps.googleusercontent.com',
          'client_secret': 'YOUR_CLIENT_SECRET',
          'refresh_token': idToken,
          'grant_type': 'refresh_token',},);
      if (response.statusCode == 200) {
        final newAccessToken = jsonDecode(response.body)['access_token'];
        await storeGoogleTokens(newAccessToken, idToken);
        print('Google access token refreshed successfully.');
      } else {
        print('Failed to refresh Google access token.');
        await googleLogout();
      }
    } catch (e) {
      print('Error during Google token refresh: $e');
    }
  }

  // تسجيل الخروج من حساب جوجل
  Future<void> googleLogout() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    user.value = null;
    Get.offAllNamed("/login");
  }

  // Future<void> googleLogin() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       return; // إذا تم إلغاء العملية
  //     }
  //
  //     // الحصول على التوثيق
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final String? accessToken = googleAuth.accessToken;
  //     final String? idToken = googleAuth.idToken;
  //
  //     // ربط مع Firebase
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: accessToken,
  //       idToken: idToken,
  //     );
  //
  //     // تسجيل الدخول مع Firebase
  //     final UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     final User? firebaseUser = userCredential.user;
  //
  //     if (firebaseUser != null) {
  //       String accessTokenEncryption =
  //           await encryption.encryptData(accessToken!);
  //       String accessTokenIdToken = await encryption.encryptData(idToken!);
  //       // تخزين الرموز بأمان باستخدام flutter_secure_storage
  //       await services.storage
  //           .write(key: 'accessToken', value: accessTokenEncryption);
  //       await services.storage.write(key: 'idToken', value: accessTokenIdToken);
  //
  //       // تعيين المستخدم في التطبيق
  //       user.value = googleUser;
  //       Get.offAllNamed("/home");
  //     }
  //   } catch (e) {
  //     print("Error during Google login: $e");
  //     Get.defaultDialog(
  //       title: "Login Error",
  //       content: Text("An error occurred during Google login: $e"),
  //     );
  //   }
  // }

  // // تحديث رمز الوصول باستخدام رمز التحديث
  // Future<void> refreshToken() async {
  //   final refreshToken = await services.storage.read(key: 'idToken');
  //   if (refreshToken == null) {
  //     print('No refresh token available.');
  //     return; // إذا لم يوجد رمز تحديث
  //   }
  //   String idToken = await encryption.decryptData(refreshToken);
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://oauth2.googleapis.com/token'),
  //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //       body: {
  //         'client_id': clientId,
  //         'client_secret': '8cc6f456cb3b3efdaee9178b4dc0bb9b8d704e66',
  //         'refresh_token': idToken,
  //         'grant_type': 'refresh_token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final newAccessToken = jsonDecode(response.body)['access_token'];
  //       String newAccessTokenEncryption =
  //           await encryption.encryptData(newAccessToken!);
  //       await services.storage
  //           .write(key: 'accessToken', value: newAccessTokenEncryption);
  //       print('Access token refreshed successfully.');
  //     } else {
  //       print('Failed to refresh access token. Logging out...');
  //       await googleLogout(); // إذا فشل التحديث، قم بتسجيل الخروج
  //     }
  //   } catch (e) {
  //     print('Error during token refresh: $e');
  //   }
  // }

  // تسجيل الخروج من Google
  // Future<void> googleLogout() async {
  //   await _googleSignIn.signOut();
  //   await FirebaseAuth.instance.signOut();
  //   user.value = null; // إعادة تعيين المستخدم
  //   Get.offAllNamed("/login"); // إعادة توجيه المستخدم إلى شاشة تسجيل الدخول
  // }

  login() async {
    FormState? formData = formKey.currentState;
    if (formData!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response =
          await authData.login(emailController.text, passwordController.text);
      statusRequest = handleData(response);
      update();
      if (statusRequest == StatusRequest.success) {
        if (response['status'] == "success") {
          // Check if the encryption key exists in storage
          String? keyString = await encryption.getEncryptionKey();
          // If key doesn't exist, generate and store a new one
          keyString ??= await encryption.generateAndStoreEncryptionKey();
          // Encrypt sensitive data before storing it
          String encryptedEmail =
              await encryption.encryptData(response['data']['users_email']);
          String encryptedName =
              await encryption.encryptData(response['data']['users_name']);
          String encryptedPassword =
              await encryption.encryptData(response['data']['users_password']);
          String encryptedId =
              await encryption.encryptData(response['data']['users_id']);
          String encryptedToken =
              await encryption.encryptData(response['token']);
          await services.storage.write(key: "token", value: encryptedToken);
          // Store encrypted data
          await services.storage.write(key: "email", value: encryptedEmail);
          await services.storage.write(key: "name", value: encryptedName);
          await services.storage
              .write(key: "password", value: encryptedPassword);
          await services.storage
              .write(key: "tokenOut", value: response['token']);
          await services.storage.write(key: "id", value: encryptedId);
          if (response['data']['users_type'] == 'admin') {
            String encryptedType = await encryption.encryptData('Admin');
            await services.storage.write(key: "type", value: encryptedType);
          } else {
            String encryptedType = await encryption.encryptData('User');
            await services.storage.write(key: "type", value: encryptedType);
          }
          Get.offAllNamed("/home");
        } else {
          Get.defaultDialog(
              title: "Error", content: Text("Email is already registered"));
          statusRequest = StatusRequest.error;
        }
      } else {}
    }
  }

  @override
  goToRegister() {
    Get.toNamed("/register");
  }
}
