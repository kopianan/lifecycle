import 'dart:async';

import 'package:flutter/material.dart';
import 'package:life_cycle/pages/home_page.dart';
import 'package:secure_application/secure_application.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  final prefs = await SharedPreferences.getInstance();
  Workmanager().executeTask((task, inputdata) async {
    switch (task) {
      case "task":
        print("Data delete from memory");
        await prefs.setBool('lock', true);
        break;

      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }

    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      child: MaterialApp(
          title: 'Flutter Demo',
          builder: (context, child) {
            return SecureApplication(
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
                  // SecureApplicationProvider.of(context)!.secure();
                  return child!;
                },
              ),
            );
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage()),
    );
  }
}
