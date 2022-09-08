import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;

//Screens
import 'package:places/screens/detail_place.dart';

//Dependencies
import 'package:provider/provider.dart';
import '../providers/places_provider.dart';
import '../models/place.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  late FToast ftoast;

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
            style: const TextStyle(fontSize: 20, color: Colors.white),
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
