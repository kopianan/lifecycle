import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';
import 'package:secure_application/secure_application_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  final ReceivePort receivePort;
  const LifeCycleManager({
    Key? key,
    required this.receivePort,
    required this.child,
  }) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Isolate? lockIsolate;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        lockIsolate!.kill(priority: Isolate.immediate);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        final _pref = await SharedPreferences.getInstance();

        var _result = _pref.getInt('delay') ?? 0;
        print(_result);

        lockIsolate = await Isolate.spawn<List>((p) async {
          await Future.delayed(Duration(seconds: p[1]), () {
            p[0].send(true);
          }); 
        }, [widget.receivePort.sendPort, _result]);

        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void doing(int data) {
    Future.delayed(Duration(seconds: data), () {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
