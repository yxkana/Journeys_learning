import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:places/models/place.dart';

class Boxes {
  static Box<Place> getPlace() => Hive.box<Place>("place4");
  static Box<PlaceLocation> getMarkers() => Hive.box<PlaceLocation>("marker4");
}
