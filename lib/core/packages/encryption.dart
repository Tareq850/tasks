import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';
import '../services/services.dart';

class Encryption {
  Services services = Get.find();
  // Asynchronous method to encrypt data
  Future<String> encryptData(String data) async {
    final encrypt.IV iv;
    if (await services.storage.read(key: "encryption_iv") != null) {
      String? encryptionIv = await services.storage.read(key: "encryption_iv");
      iv = encrypt.IV.fromBase64(encryptionIv!);
    } else {
      iv = encrypt.IV.fromLength(16);
    }
    final keyString = await getEncryptionKey(); // Await the key asynchronously
    print(keyString);
    if (keyString == null ||
        (keyString.length != 16 &&
            keyString.length != 24 &&
            keyString.length != 32)) {
      generateAndStoreEncryptionKey();
      throw Exception(
          "Invalid key length. Key must be 16, 24, or 32 characters long.");
    }
    final encrypter =
        encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(keyString)));
    final encrypted = encrypter.encrypt(data, iv: iv);
    await services.storage.write(key: "encryption_iv", value: iv.base64);
    return encrypted.base64; // Return the encrypted text as base64
  }
  Future<String> decryptData(String encryptedData) async {
    String? encryptionIv = await services.storage.read(key: "encryption_iv");
    final iv = encrypt.IV.fromBase64(encryptionIv!);
    final keyString = await services.storage.read(key: "encryption_key");
    if (keyString == null) {
      throw Exception("Encryption key not found");
    }
    final encrypter =
        encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(keyString)));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }
  // This function can be called to generate a new encryption key if none exists
  Future<String> generateAndStoreEncryptionKey() async {
    // Generate a 32-character encryption key (e.g., you can use a random generator or a predefined key)
    const String generatedKey =
        "12345678910123456789102345678910"; // Example of a predefined key
    await services.storage.write(
        key: "encryption_key",
        value: generatedKey); // Store the generated key securely
    return generatedKey;
  }
  // Retrieve encryption key securely
  Future<String?> getEncryptionKey() async {
    return await services.storage.read(key: "encryption_key");
  }
}
