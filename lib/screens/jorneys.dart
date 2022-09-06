import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          title: Text(
        "Jorneys",
        style: TextStyle(color: Color.fromARGB(255, 235, 224, 225)),
      )),
      body: Center(
          child: Text("Jorneys",
              style: TextStyle(color: Color.fromARGB(255, 96, 116, 137)))),
    );
  }
}
