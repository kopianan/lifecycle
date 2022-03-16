import 'dart:io';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricHelper {
  static final BiometricHelper _instance = BiometricHelper._internal();
  BiometricHelper._internal();
  final _auth = LocalAuthentication();

  factory BiometricHelper() {
    return _instance;
  }

  Future<bool> hasBiometrics() async {
    try {
      var _result = await _auth.canCheckBiometrics;
      return _result;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        throw Exception('Device does not support Fingerprint/FaceID');
      }
      throw Exception('Something wrong on biometrics');
    }
  }

  Future<bool> authenticate() async {
    //Check if device support for biometrics or not
    final _isAvailable = await hasBiometrics();
    if (!_isAvailable) return false;

    //Check what kind of biometrics on phone
    try {
      var _result = await _auth.authenticate(
          localizedReason: await _checkAvailabality(),
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true);
      return _result;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<String> _checkAvailabality() async {
    List<BiometricType> _availableBiometrics;

    _availableBiometrics = await _auth.getAvailableBiometrics();
    String reason;
    if (Platform.isIOS) {
      if (_availableBiometrics.contains(BiometricType.face)) {
        reason = "Gunakan Face ID untuk melakukan autentikasi.";
      } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        reason = "Gunakan Touch ID untuk melakukan autentikasi.";
      } else {
        reason = "Gunakan Iris untuk melakukan autentikasi.";
      }
    } else {
      reason = "Gunakan Fingerprint untuk melakukan autentikasi.";
    }

    return reason;
  }

  Future<bool> cancelBiometrics() async {
    try {
      var _result = await _auth.stopAuthentication();
      return _result;
    } on PlatformException catch (e) {
      return true;
    }
  }

  Future<bool> _startBiometric() async {
    var _auth = LocalAuthentication();

    bool isBioMetricSupported = false;

    //if false, the device is not support
    if (await _auth.isDeviceSupported()) {
      isBioMetricSupported = true;
    }

    try {
      var didAuthenticate = await _auth.authenticateWithBiometrics(
        localizedReason: await _checkAvailabality(),
        stickyAuth: true,
        // biometricOnly: isBioMetricSupported,
        useErrorDialogs: true,
      );

      if (didAuthenticate) {
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      print(e.code);

      // if (e.code == auth_error.notAvailable) {
      throw Exception(e.message);
      // } else {
      //   throw Exception(e.message);
      // }
    }
  }

  // Future<String?> readDataWithAuthentication(String key) async {
  //   final _localStorage = LocalSecureStorageHelper();

  //   final _biometric = await _startBiometric();
  //   if (_biometric) {
  //     return await _localStorage.readData(key: key);
  //   }
  //   return null;
  // }
}
