import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:life_cycle/life_cycle_manager.dart';
import 'package:life_cycle/pages/home_page.dart';
import 'package:life_cycle/pages/pin_page.dart';
import 'package:secure_application/secure_application.dart';

import 'helpers/notification_service.dart';

const simpleTaskKey = "task";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort receivePort = ReceivePort();
  final _controller = SecureApplicationController(SecureApplicationState());

  @override
  void initState() {
    super.initState();
    receivePort.listen((message) {
      var _result = message ?? false;
      if (_result) {
        _controller.lock();
        print(_controller.locked);
        print("Application Is Locked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure application',
      home: HomePage(),
      builder: (context, child) {
        return SecureApplication(
          secureApplicationController: _controller,
          nativeRemoveDelay: 1000,
          onNeedUnlock: (secure) async {},
          onAuthenticationFailed: () async {
            print('auth failed');
          },
          onAuthenticationSucceed: () async {
            print('auth success');
          },
          child: Builder(
            builder: (context) {
              return SecureGate(
                // 1
                blurr: 20,
                // 2
                opacity: 0.5,
                // 3
                lockedBuilder: (context, secureNotifier) => PinPage(
                  secure: secureNotifier,
                  onUnlock: () {
                    _controller.unlock();
                  },
                ),
                child:
                    LifeCycleManager(receivePort: receivePort, child: child!),
              );
            },
          ),
        );
      },
    );
  }
}
