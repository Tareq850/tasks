import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication auth = LocalAuthentication();
  Future<bool> isBiometricAvailable() async {
    return await auth.canCheckBiometrics && await auth.isDeviceSupported();
  }
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to access encrypted data',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }
}
