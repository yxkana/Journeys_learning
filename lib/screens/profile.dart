import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          title: Text("Profile",
              style: TextStyle(color: Color.fromARGB(255, 235, 224, 225)))),
      body: Center(
          child: Text(
        "This gonna be a profile",
        style: TextStyle(color: Color.fromARGB(255, 96, 116, 137)),
      )),
    );
  }
}
