import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:life_cycle/helpers/biometric_helper.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_application/secure_application.dart';

class PinPage extends StatefulWidget {
  const PinPage({Key? key, required this.secure, required this.onUnlockSuccess}) : super(key: key);
  final SecureApplicationController? secure;
  final Function onUnlockSuccess;

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  @override
  Widget build(BuildContext context) {
    //[WillPopScope] will return false, it means the page can not be close.
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 124, 253),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 150,
            ),
            SizedBox(height: 30),
            const Text(
              "Hey!!\nThis is Where you can unlock your apps",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                var _bio = BiometricHelper();
                final _result = await _bio.authenticate();
                if (_result) {
                  widget.secure!.unlock();
                }
              },
              child: const Text("Unlock With Biometrics"),
            ),
            ElevatedButton(
              onPressed: () async {
                widget.secure!.unlock();
                widget.onUnlockSuccess();
              },
              child: const Text("Unlock with pin (unlock success)"),
            ),
          ],
        ),
      ),
    );
  }
}
