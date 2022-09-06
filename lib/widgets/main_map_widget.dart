import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';

import 'package:places/models/place.dart';
import 'package:places/screens/detail_place.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';

class mainMap extends StatefulWidget {
  List<Place> searchMap;
  List<Place> marker;
  TextEditingController _searchController;
  LatLng userLocation;

  mainMap(
      this.searchMap, this._searchController, this.userLocation, this.marker);

  List<Marker> markers = [];
  List<Marker> defaultMarkers = [];
  List<Marker> imgMarkers = [];
  Set<Marker> iconMarkers = {};

  @override
  State<mainMap> createState() => _mainMapState();
}

class _mainMapState extends State<mainMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<Place> searchPlace = [];
  List<Uint8List> convertImgToMarkerList = [];
  int saveLock = 0;
  int saveLockMarkerText = 0;
  bool switchMarkers = false;
  bool doubleTap = true;
  int click = 0;
  String currentMarker = "";
  bool imgIcon = false;
  bool tagIcon = false;
  Timer? timer;

  ByteData convertImg(String imgString) {
    File file = File(imgString);
    Uint8List bytes = file.readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }

  Future<ui.Image> addImg(String imgString, int width, int height) async {
    ui.Codec codec = await ui.instantiateImageCodec(
        convertImg(imgString).buffer.asUint8List(),
        targetHeight: height,
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return fi.image;
  }
  

  //----------------------------------------------------------------------------
  //Create bluePrint for marker with Img
  Future<Uint8List> canvasImg(
      IconsData icon, Size size, BuildContext context, String imgg) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(20);

    Paint paint0 = Paint();

    Path path0 = Path();
    path0.moveTo(size.width * 0.5000000, size.height * 0.9857143);
    path0.quadraticBezierTo(size.width * 0.4582250, size.height * 0.8428571,
        size.width * 0.3750000, size.height * 0.8571429);
    path0.quadraticBezierTo(size.width * 0.3339833, size.height * 0.8577857,
        size.width * 0.3108333, size.height * 0.8214286);
    path0.quadraticBezierTo(size.width * 0.2924083, size.height * 0.7865286,
        size.width * 0.2916667, size.height * 0.7142857);
    path0.lineTo(size.width * 0.2916667, size.height * 0.2857143);
    path0.quadraticBezierTo(size.width * 0.2916917, size.height * 0.2149143,
        size.width * 0.3125583, size.height * 0.1790143);
    path0.quadraticBezierTo(size.width * 0.3338417, size.height * 0.1436857,
        size.width * 0.3750000, size.height * 0.1428571);
    path0.lineTo(size.width * 0.6250000, size.height * 0.1428571);
    path0.quadraticBezierTo(size.width * 0.6668750, size.height * 0.1426286,
        size.width * 0.6877083, size.height * 0.1794714);
    path0.quadraticBezierTo(size.width * 0.7089583, size.height * 0.2149571,
        size.width * 0.7083333, size.height * 0.2857143);
    path0.lineTo(size.width * 0.7083333, size.height * 0.7142857);
    path0.quadraticBezierTo(size.width * 0.7087000, size.height * 0.7865143,
        size.width * 0.6875000, size.height * 0.8214286);
    path0.quadraticBezierTo(size.width * 0.6671250, size.height * 0.8577857,
        size.width * 0.6250000, size.height * 0.8571429);
    path0.quadraticBezierTo(size.width * 0.5417667, size.height * 0.8440429,
        size.width * 0.5000000, size.height * 0.9857143);
    path0.close();

    //canvas.drawPath(path0, paint0);
    canvas.clipPath(path0);
    canvas.drawImage(await addImg(imgg, 125, 175), Offset(90, 20), paint0);

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  //----------------------------------------------------------------------------
  //Create bluePrint for marker with Icon
  Future<Uint8List> canvasIcon(IconsData icon, Size size, BuildContext context,
      String imgg, Place place) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(20);

    Paint paint0 = Paint()
      ..color = Theme.of(context).colorScheme.secondary.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    Path path0 = Path();
    path0.moveTo(size.width * 0.5000000, size.height * 0.9857143);
    path0.quadraticBezierTo(size.width * 0.4582250, size.height * 0.8428571,
        size.width * 0.3750000, size.height * 0.8571429);
    path0.quadraticBezierTo(size.width * 0.3339833, size.height * 0.8577857,
        size.width * 0.3108333, size.height * 0.8214286);
    path0.quadraticBezierTo(size.width * 0.2924083, size.height * 0.7865286,
        size.width * 0.2916667, size.height * 0.7142857);
    path0.lineTo(size.width * 0.2916667, size.height * 0.2857143);
    path0.quadraticBezierTo(size.width * 0.2916917, size.height * 0.2149143,
        size.width * 0.3125583, size.height * 0.1790143);
    path0.quadraticBezierTo(size.width * 0.3338417, size.height * 0.1436857,
        size.width * 0.3750000, size.height * 0.1428571);
    path0.lineTo(size.width * 0.6250000, size.height * 0.1428571);
    path0.quadraticBezierTo(size.width * 0.6668750, size.height * 0.1426286,
        size.width * 0.6877083, size.height * 0.1794714);
    path0.quadraticBezierTo(size.width * 0.7089583, size.height * 0.2149571,
        size.width * 0.7083333, size.height * 0.2857143);
    path0.lineTo(size.width * 0.7083333, size.height * 0.7142857);
    path0.quadraticBezierTo(size.width * 0.7087000, size.height * 0.7865143,
        size.width * 0.6875000, size.height * 0.8214286);
    path0.quadraticBezierTo(size.width * 0.6671250, size.height * 0.8577857,
        size.width * 0.6250000, size.height * 0.8571429);
    path0.quadraticBezierTo(size.width * 0.5417667, size.height * 0.8440429,
        size.width * 0.5000000, size.height * 0.9857143);
    path0.close();

    canvas.drawPath(path0, paint0);

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: 75,
            fontFamily: icon.fontFamily,
            color: Theme.of(context).colorScheme.primary));
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((300 * 0.5) - textPainter.width * 0.5,
            (175 * 0.5) - textPainter.height * 0.5));

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<Set<Marker>> renderIcon(
      BuildContext context, int width, int height) async {
    widget.marker.forEach((element) async {
      final Uint8List markerIcon = await canvasIcon(
          element.listIcons.first,
          Size(width.toDouble(), height.toDouble()),
          context,
          element.gallery.first,
          element);
      setState(() {
        saveLock++;
        widget.iconMarkers.add(Marker(
            infoWindow: InfoWindow(
                title: element.title,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Detail_screen(element.id,element)));
                },
                snippet: "Click to Gallery"),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            markerId: MarkerId(element.location!.idLoc),
            position: LatLng(
                element.location!.latitude, element.location!.longitude)));
      });
    });

    return widget.iconMarkers;
  }

  Future<List<Marker>> renderImg(
      BuildContext context, int width, int height) async {
    widget.marker.forEach((element) async {
      final Uint8List markerIcon = await canvasImg(
          element.listIcons.first,
          Size(width.toDouble(), height.toDouble()),
          context,
          element.gallery.first);
      setState(() {
        saveLock++;
        widget.imgMarkers.add(Marker(
            infoWindow: InfoWindow(
                title: element.title,
                snippet: "Click to Gallery",
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Detail_screen(element.id,element)));
                })),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            markerId: MarkerId(element.location!.idLoc),
            position: LatLng(
                element.location!.latitude, element.location!.longitude)));
      });
    });

    return widget.imgMarkers;
  }

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    
    searchPlace.addAll(widget.marker);
    timer = Timer(Duration(milliseconds: 200), (() {}));
  }

  @override
  Widget build(BuildContext context) {
    /* setState(() {
      widget.marker.forEach((element) {
        widget.loadingMarkers.add(Marker(markerId: MarkerId(element.id)));
      });
    }); */

    return Stack(children: [
      GoogleMap(
          onTap: (argument) {
            doubleTap = true;
          },
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) async {
            if (saveLock <= widget.marker.length) {
              renderIcon(context, 300, 175);

              renderImg(context, 300, 175);
            }

            _controller.complete(controller);
          },
          markers: switchMarkers
              ? widget.imgMarkers.toSet()
              : widget.iconMarkers.toSet(),
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.userLocation.latitude, widget.userLocation.longitude),
              zoom: 14)),
      Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07, right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      iconSize: 35,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: PlaceSearch(searchPlace, _controller));
                      },
                      icon: Icon(
                        Icons.search,
                        size: 35,
                      )))),
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      iconSize: 35,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        setState(() {
                          switchMarkers = !switchMarkers;
                        });

                        widget.imgMarkers.forEach((element) {
                          element.icon;
                        });
                      },
                      icon: switchMarkers
                          ? Icon(
                              Icons.photo_camera_back_outlined,
                            )
                          : Icon(Icons.pin_drop_outlined)))),
        ],
      ),
    ]);
  }
}

class PlaceSearch extends SearchDelegate<String> {
  final List<Place> _searchMap;
  final Completer<GoogleMapController> _controller;

  PlaceSearch(this._searchMap, this._controller);

  Future<void> _goToTheLake(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 17)));
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, "");
              } else {
                query = "";
              }
            },
            icon: Icon(Icons.clear))
      ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, "");
      },
      icon: Icon(Icons.arrow_back));
  @override
  Widget buildResults(BuildContext context) => Center();
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Place> suggestions = _searchMap.where((element) {
      final placeTitle = element.title.toLowerCase();
      final input = query.toLowerCase();
      return placeTitle.startsWith(input);
    }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<Place> suggestions) => ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: ((context, index) {
        final quaryText = suggestions[index].title.substring(0, query.length);
        final remainingText = suggestions[index].title.substring(query.length);

        return ListTile(
            onTap: () async {
              await _goToTheLake(suggestions[index].location!.latitude,
                      suggestions[index].location!.longitude)
                  .then((value) => close(context, ""));
            },
            leading: Icon(IconData(suggestions[index].listIcons.first.codePoint,
                fontFamily: suggestions[index].listIcons.first.fontFamily,
                fontPackage: suggestions[index].listIcons.first.fontPackage,
                matchTextDirection:
                    suggestions[index].listIcons.first.textDirection)),
            //title: Text(suggestions[index].title),
            title: RichText(
              text: TextSpan(
                  text: quaryText,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  children: [
                    TextSpan(
                        text: remainingText,
                        style: TextStyle(color: Colors.grey, fontSize: 18))
                  ]),
            ));
      }));
}
