import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';

part "place.g.dart";

@HiveType(typeId: 1)
class PlaceLocation extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late double latitude;
  @HiveField(1)
  late double longitude;
  @HiveField(2)
  late String address;
  @HiveField(3)
  late String idLoc;

  PlaceLocation(this.latitude, this.longitude, this.address, this.idLoc);
}

@HiveType(typeId: 2)
class PlaceTag extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late bool monument = false;
  @HiveField(1)
  late bool city = false;
  @HiveField(2)
  late bool experience = false;
  @HiveField(3)
  late bool vacation = false;
  @HiveField(4)
  late bool work = false;
  @HiveField(5)
  late bool project = false;
  @HiveField(6)
  late bool personal = false;
  @HiveField(7)
  late bool vista = false;

  PlaceTag(this.monument, this.city, this.experience, this.vacation, this.work,
      this.project, this.personal, this.vista);
}

@HiveType(typeId: 3)
class IconsData extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late int codePoint;
  @HiveField(1)
  late String? fontFamily;
  @HiveField(2)
  late String? fontPackage;
  @HiveField(3)
  late bool textDirection;

  IconsData(
      this.codePoint, this.fontFamily, this.fontPackage, this.textDirection);
}

@HiveType(typeId: 0)
class Place extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late PlaceLocation? location;
  @HiveField(3)
  late List<String> gallery;
  @HiveField(4)
  late List<String> dates;
  @HiveField(5)
  late PlaceTag? tag;
  @HiveField(6)
  late Map<String, bool> tagsOfPlaces;
  @HiveField(7)
  late List<IconsData> listIcons;

  Place(
      {required this.id,
      required this.title,
      required this.location,
      required this.gallery,
      required this.dates,
      required this.tag,
      required this.tagsOfPlaces,
      required this.listIcons});
}

class Gallery extends HiveObject {}
