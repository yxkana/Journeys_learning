import 'package:flutter/material.dart';

Widget toastPhotoAdded = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Color.fromRGBO(156, 180, 204, 1),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.check,
        color: Colors.white,
      ),
      SizedBox(
        width: 12.0,
      ),
      Text("Photo added",
          style: TextStyle(
              color: Colors.white, fontFamily: "RobotoRegular", fontSize: 16)),
    ],
  ),
);

Widget toastPlaceAdded = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Color.fromRGBO(156, 180, 204, 1),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.check,
        color: Colors.white,
      ),
      SizedBox(
        width: 12.0,
      ),
      Text(
        "Place added",
        style: TextStyle(
            color: Colors.white, fontFamily: "RobotoRegular", fontSize: 16),
      ),
    ],
  ),
);

Widget toastMapUpdated = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Color.fromRGBO(156, 180, 204, 1),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.check,
        color: Colors.white,
      ),
      SizedBox(
        width: 12.0,
      ),
      Text(
        "Map Updated",
        style: TextStyle(
            color: Colors.white, fontFamily: "RobotoRegular", fontSize: 16),
      ),
    ],
  ),
);

Widget somethingGotWrong = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Color.fromRGBO(156, 180, 204, 1),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      SizedBox(
        width: 12.0,
      ),
      Text(
        "Something is wrong...",
        style: TextStyle(
            color: Colors.white, fontFamily: "RobotoRegular", fontSize: 16),
      ),
    ],
  ),
);
