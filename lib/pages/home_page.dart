import 'package:flutter/material.dart';
import 'package:life_cycle/pages/page_one.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_encryption_gmailerrorred,
              size: 150,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "If you close the apps from here,  will not be locked",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => PageOne())));
                },
                child: Text("Go To Secure Page"))
          ],
        ));
  }
}
