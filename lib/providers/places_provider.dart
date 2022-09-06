import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

import '../widgets/Boxes.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import 'dart:convert';
import '../helpers/Utility.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  bool tagPreserver = false;

  Map<String, bool> tagMap = {
    "Monument": false,
    "City": false,
    "Experience": false,
    "Vacation": false,
    "Work": false,
    "Personal": false,
    "Project": false,
    "Vista": false,
  };

  List<Place> get items {
    return [..._items];
  }

  final Map<String, bool> _placeMap = {};
  final List decodeIconList = [];

  List<Place> _tagPlaceMap = [];
  List<Place> get tagPlaceMap {
    return [..._tagPlaceMap];
  }

  List<Place> listOfPlaces = [];
  List<Place> get _listOfPlaces {
    return [...listOfPlaces];
  }

  List<String> _searchList = [];
  List<String> get searchList {
    return [..._searchList];
  }

  List<Place> get tagMonument {
    return _listOfPlaces
        .where((element) => element.tag!.monument == true)
        .toList();
  }

  List<Place> get tagCity {
    return _listOfPlaces.where((element) => element.tag!.city == true).toList();
  }

  List<Place> get tagExperience {
    return _listOfPlaces
        .where((element) => element.tag!.experience == true)
        .toList();
  }

  List<Place> get tagVacation {
    return _listOfPlaces
        .where((element) => element.tag!.vacation == true)
        .toList();
  }

  List<Place> get tagWork {
    return _listOfPlaces.where((element) => element.tag!.work == true).toList();
  }

  List<Place> get tagPersonal {
    return _listOfPlaces
        .where((element) => element.tag!.personal == true)
        .toList();
  }

  List<Place> get tagProject {
    return _listOfPlaces
        .where((element) => element.tag!.project == true)
        .toList();
  }

  List<Place> get tagVista {
    return _listOfPlaces
        .where((element) => element.tag!.vista == true)
        .toList();
  }

  addPlace(String pickedTitle, List<String> gallery, PlaceLocation location,
      String id, PlaceTag tag, List<IconsData> iconList) {
    _placeMap.addAll({
      "Monument": tag.monument,
      "City": tag.city,
      "Experience": tag.experience,
      "Vacation": tag.vacation,
      "Work": tag.work,
      "Personal": tag.personal,
      "Project": tag.project,
      "Vista": tag.vista,
    });

    final newPlace = Place(
        id: id,
        title: pickedTitle,
        location: location,
        gallery: gallery,
        dates: [DateTime.now().toIso8601String()],
        tag: PlaceTag(tag.monument, tag.city, tag.experience, tag.vacation,
            tag.work, tag.project, tag.personal, tag.vista),
        tagsOfPlaces: _placeMap,
        listIcons: iconList);

    _items.add(newPlace);
    Hive.box<Place>("place4").add(newPlace);

    notifyListeners();
  }

  confirmsearch() {
    tagPreserver = true;
    notifyListeners();
  }

  cancelsearch() {
    tagPreserver = false;
    notifyListeners();
  }

  deletePlace(String id) async {
    final deleteIteIndex = _items.indexWhere((element) => element.id == id);

    _items.removeAt(deleteIteIndex);

    notifyListeners();
  }

  updatePlacePhoto(String img, Place place) async {
    place.gallery.add(img);
    place.save();
  }

  addItemToTagList(Place place) {
    _tagPlaceMap.add(place);
  }

  removeItemFromTagList(Place place) {
    _tagPlaceMap.remove(place);
  }

  updateMapLocation(double lat, double long, Place place) {
    place.location!.longitude = long;
    place.location!.latitude = lat;
    place.save();
  }

  updateTitle(String title, Place place) {
    place.title = title;
    place.save();
  }

  updateTag(Place place, Map<String, bool> map, PlaceTag? tag,
      List<IconsData> _iconList) {
    place.tagsOfPlaces = map;
    place.tag = tag;
    place.listIcons = _iconList;
    place.save();
  }

  deletePhoto(Place place, int index) {
    place.gallery.removeAt(index);

    place.save();
  }

  deletePhotos(Place place, List<String> listForDelete) {
    place.gallery.removeWhere((element) => listForDelete.contains(element));
  }
}
