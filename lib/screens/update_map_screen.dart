import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:places/screens/map.dart';
import 'package:places/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:places/models/place.dart';

import 'package:provider/provider.dart';
import 'package:places/providers/places_provider.dart';

//AIzaSyCi7dFt4IfqxQ7v9umJCKBHE-e_mIEKle8

class Updatemap extends StatefulWidget {
  double latitude;
  double longtidue;
  Place place;

  Updatemap(this.latitude, this.longtidue, this.place);

  @override
  State<Updatemap> createState() => _UpdatemapState();
}

class _UpdatemapState extends State<Updatemap> {
  late FToast ftoast;

  late final PlaceLocation position;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    ftoast = FToast();
    ftoast.init(context);
    setState(() {
      _pickedLocation = LatLng(widget.latitude, widget.longtidue);
    });
  }

  LatLng _pickedLocation = LatLng(0, 0);
  bool isTaped = false;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
      isTaped = true;
    });
  }

  void _saveLocation() {
    Provider.of<PlacesProvider>(context, listen: false).updateMapLocation(
        _pickedLocation.latitude, _pickedLocation.longitude, widget.place);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Map")),
        body: SizedBox.expand(
          child: Container(
              child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude, widget.longtidue),
                  zoom: 16,
                ),
                onTap: _selectLocation,
                markers: {
                  Marker(markerId: MarkerId("m1"), position: _pickedLocation)
                },
              ),
            ],
          )),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.03),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.4,
            child: FloatingActionButton(
              heroTag: "fab",
              onPressed: (() {
                _saveLocation();
                ftoast.showToast(
                    child: toastMapUpdated,
                    gravity: ToastGravity.CENTER,
                    toastDuration: Duration(seconds: 1));
              }),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Update Map",
                      style: TextStyle(
                          color: Color.fromRGBO(244, 238, 255, 1),
                          fontFamily: "NexaTextRegular",
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Icon(
                      Icons.add_location_alt_rounded,
                      color: Color.fromRGBO(244, 238, 255, 1),
                    )
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
