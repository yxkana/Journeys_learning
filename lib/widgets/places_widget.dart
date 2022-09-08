import 'package:flutter/material.dart';
import 'dart:io';

//Screens
import '../screens/update_map_screen.dart';
//Models
import '../models/place.dart';

//Dependencies
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:places/screens/detail_place.dart';

//widgets
import '../widgets/Toast.dart';

//Provider
import '../providers/places_provider.dart';

// ignore: must_be_immutable
class PlacesGrid extends StatefulWidget {
  final Place _places;
  final int index;
  final List<Place> searchList;

  // ignore: use_key_in_widget_constructors
  const PlacesGrid(this._places, this.index, this.searchList);

  @override
  State<PlacesGrid> createState() => _PlacesGridState();
}

class _PlacesGridState extends State<PlacesGrid> with TickerProviderStateMixin {
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerAddPhotoButton.dispose();
    _controllerDeletePhotoButton.dispose();
    _controllerShowPlaceButton.dispose();
    _controllerUpdateMapButton.dispose();
    _opacityController.dispose();
  }

  @override
  void initState() {
    super.initState();
    ftoast = FToast();
    ftoast.init(context);

    //Controller
    _controllerAddPhotoButton =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _controllerDeletePhotoButton =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _controllerUpdateMapButton =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _controllerShowPlaceButton =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _opacityController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    //DeleteButtonAnimation
    _slideAnimationButtonDelete =
        Tween<Offset>(begin: Offset(0, -3), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _controllerDeletePhotoButton, curve: Curves.linear));

    //AddButtonAnimationMap
    _slideAnimationButtonMap =
        Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _controllerUpdateMapButton, curve: Curves.linear));

    //AddButtonAdd
    _slideAnimationButtonAdd =
        Tween<Offset>(begin: Offset(0, -2), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _controllerAddPhotoButton, curve: Curves.linear));

    //AddButtonShow
    _slideAnimationButtonShow =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _controllerShowPlaceButton, curve: Curves.linear));

    //Add opacity
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _opacityController, curve: Curves.easeIn));
  }

  List<Icon> list = [Icon(Icons.add), Icon(Icons.add)];

  @override
  Widget build(BuildContext context) {
    final tag = StringBuffer();
    final places = Provider.of<PlacesProvider>(context);

    tag.writeAll([widget._places.id, 0]);
    return Hero(
      tag: widget._places.gallery.first + widget._places.id + 0.toString(),
      child: GestureDetector(
        onTap: (() async {
          setState(() {
            isTap = !isTap;
            if (isTap) {
              _controllerShowPlaceButton.forward();
              _controllerAddPhotoButton.forward();
              _controllerUpdateMapButton.forward();
              _controllerDeletePhotoButton.forward();
              _opacityController.forward();
            } else {
              _controllerShowPlaceButton.reverse();
              _controllerUpdateMapButton.reverse();
              _controllerDeletePhotoButton.reverse();
              _controllerAddPhotoButton.reverse();
              _opacityController.reverse();
            }
          });
        }),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: GridTile(
            footer: Padding(
              padding: const EdgeInsets.all(12),
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                    fontSize: isTap ? 25 : 20,
                    color: Theme.of(context).colorScheme.tertiary),
                duration:const Duration(milliseconds: 2000),
                child: Text(
                  widget._places.title,
                ),
              ),
            ),
            header: isTap
                ? Padding(
                    padding: const EdgeInsets.all(7),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration:const Duration(milliseconds: 200),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimationButtonShow,
                                child: IconButton(
                                    onPressed: () {
                                     
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Detail_screen(
                                                      widget._places.id,
                                                      widget._places)));
                                    },
                                    icon: Icon(
                                      Icons.photo_album_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 25,
                                    )),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration:const Duration(milliseconds: 200),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimationButtonMap,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Updatemap(
                                                  widget._places.location!
                                                      .latitude,
                                                  widget._places.location!
                                                      .longitude,
                                                  widget._places)));
                                    },
                                    icon: Icon(
                                      Icons.map,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 25,
                                    )),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration:const Duration(milliseconds: 200),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimationButtonAdd,
                                child: IconButton(
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      final imageFile = await picker.getImage(
                                        source: ImageSource.camera,
                                      );
                                      if (imageFile == null) {
                                        null;
                                      }
                                      setState(() {
                                        _storedImage = File(imageFile!.path);
                                      });
                                      final appDir = await sysPath
                                          .getApplicationDocumentsDirectory();
                                      final fileName =
                                          path.basename(imageFile!.path);

                                      final savedImage =
                                          await File(imageFile.path)
                                              .copy("${appDir.path}/$fileName");

                                      String StringImg;

                                      places.updatePlacePhoto(
                                          savedImage.path, widget._places);

                                      ftoast.showToast(
                                          child: toastPhotoAdded,
                                          positionedToastBuilder:
                                              (context, child) {
                                            return Positioned(
                                              child: child,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  1.7,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                            );
                                          },
                                          toastDuration: Duration(seconds: 2));
                                    },
                                    icon: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 25,
                                    )),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimationButtonDelete,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  content: const Text(
                                                      "Do you want to remove this Place ?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: (() {
                                                          setState(() {
                                                            widget._places
                                                                .delete();

                                                            isTap = false;
                                                          });
                                                          widget.searchList
                                                              .remove(widget
                                                                  ._places);
                                                          Navigator.of(context)
                                                              .pop();

                                                          ftoast.showToast(
                                                              child:
                                                                  JourneyDeleted,
                                                              toastDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        }),
                                                        child:const Text("Yes")),
                                                    TextButton(
                                                        onPressed: (() =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop()),
                                                        child:const Text("No"))
                                                  ],
                                                ));
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      size: 25,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(widget._places.gallery.first),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<Icon> buildMenuItem(Icon icon) =>
      DropdownMenuItem(value: icon, child: Icon(icon.icon));
}
