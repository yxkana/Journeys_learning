import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:places/screens/detail_place.dart';
import 'package:places/screens/places.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import '../providers/places_provider.dart';
import '../models/place.dart';

//Hive
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;

import 'package:image_picker/image_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/Toast.dart';
import '../screens/update_map_screen.dart';

// ignore: must_be_immutable
class SearchGrid extends StatefulWidget {
  final Place _places;
  final int index;
  final List<Place> searchList;
  final List<Place> searhPlace;

  // ignore: use_key_in_widget_constructors
  const SearchGrid(this._places, this.index, this.searchList, this.searhPlace);

  @override
  State<SearchGrid> createState() => _PlacesGridState();
}

class _PlacesGridState extends State<SearchGrid> with TickerProviderStateMixin {
  bool isTap = false;
  File? _storedImage;
  late FToast ftoast;

  late AnimationController _controllerAddPhotoButton;
  late AnimationController _controllerDeletePhotoButton;
  late AnimationController _controllerUpdateMapButton;
  late AnimationController _controllerShowPlaceButton;
  late AnimationController _opacityController;

  late Animation<Offset> _slideAnimationButtonDelete;
  late Animation<Offset> _slideAnimationButtonAdd;
  late Animation<Offset> _slideAnimationButtonShow;
  late Animation<Offset> _slideAnimationButtonMap;
  late Animation<double> _opacityAnimation;

  List<Icon> list = [Icon(Icons.add), Icon(Icons.add)];

  @override
  Widget build(BuildContext context) {
    final tag = StringBuffer();
    final places = Provider.of<PlacesProvider>(context);

    tag.writeAll([widget._places.id, 0]);
    return GestureDetector(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Detail_screen(widget._places.id, widget._places)));
      }),
      child: GridTile(
        footer: Padding(
          padding: const EdgeInsets.all(12),
          child: AnimatedDefaultTextStyle(
            style: TextStyle(fontSize: isTap ? 30 : 20, color: Colors.white),
            duration: Duration(milliseconds: 2000),
            child: Text(
              widget._places.title,
            ),
          ),
        ),
        child: Hero(
          tag: widget._places.gallery.first + widget._places.id + 0.toString(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              File(widget._places.gallery.first),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<Icon> buildMenuItem(Icon icon) =>
      DropdownMenuItem(value: icon, child: Icon(icon.icon));
}
