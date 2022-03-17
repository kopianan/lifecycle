import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:life_cycle/pages/pin_page.dart';
import 'package:life_cycle/pages/setting_page.dart';
import 'package:secure_application/secure_application.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page ONE"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingPage(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
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
              "Open setting kanan atas untuk mengatur delay",
              style: TextStyle(fontSize: 17),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
