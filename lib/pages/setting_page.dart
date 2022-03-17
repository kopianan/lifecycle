import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var _lockTime = [
    LockTime('5 Seconds', 5),
    LockTime('15 Seconds', 15),
    LockTime('30 Seconds', 30),
    LockTime('60 Seconds', 60),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
            children: _lockTime
                .map((e) => ListTile(
                      title: Text(e.title),
                      onTap: () async {
                        //Save to sharedpreferences
                        final _pref = await SharedPreferences.getInstance();
                        _pref.setInt('delay', e.seconds);
                        Navigator.of(context).pop();
                      },
                    ))
                .toList()),
      ),
    );
  }
}

class LockTime {
  String title;
  int seconds;
  LockTime(this.title, this.seconds);
}
