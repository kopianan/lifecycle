import 'package:flutter/material.dart';
import 'package:life_cycle/pages/pin_page.dart';
import 'package:secure_application/secure_application.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> with WidgetsBindingObserver {
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => prefs = value);

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  bool isLocked = true;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        var _result = prefs.getBool('lock');
        print(_result);
        if (_result!) {
          print("apps is locked");
          //If apps is lock
          SecureApplicationProvider.of(context)!.secure();
          SecureApplicationProvider.of(context)!.lock();
        }
        Workmanager().cancelByUniqueName("2");
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        //start task /WORKMANAGER
        Workmanager().registerOneOffTask(
          "2",
          "task",
          initialDelay: Duration(seconds: 5),
        );

        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecureGate(
      lockedBuilder: (context, secure) {
        return PinPage(
          secure: secure,
          onUnlockSuccess: () {},
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Page ONE")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(
              size: 100,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Note : Jika pause aplikasi di halaman ini maka aplikasi akan terkunci.",
                style: TextStyle(fontSize: 17),
              ),
            ),
            SizedBox(height: 30),
            Builder(builder: (context) {
              SecureApplicationProvider.of(context)!.lockEvents.listen((event) {
                setState(() {
                  isLocked = event;
                });
              });
              return Visibility(
                visible: isLocked,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Yeay, You just unlock the phone",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          SecureApplicationProvider.of(context)!.lock();
                          setState(() {
                            isLocked = !isLocked;
                          });
                        },
                        child: Text("Lock Apps")),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
