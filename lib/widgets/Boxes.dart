import 'package:flutter/material.dart';
//Dependencies
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//Models
import 'package:places/models/place.dart';

class Boxes {
  static Box<Place> getPlace() => Hive.box<Place>("place4");
  static Box<PlaceLocation> getMarkers() => Hive.box<PlaceLocation>("marker4");
}
