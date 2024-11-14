import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class Services extends GetxService{
  late SharedPreferences sharedPreferences;
  late FlutterSecureStorage storage;

  Future<Services> init() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    sharedPreferences = await SharedPreferences.getInstance();
    storage = const FlutterSecureStorage();
    return this;
  }
}


initServices() async {
  await Get.putAsync(() => Services().init());
}