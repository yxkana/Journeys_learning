import 'package:flutter/material.dart';
import 'dart:io';

//Dependencies
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

//Data
import '../data/tag_data.dart';

//Providers
import '../providers/places_provider.dart';

//Models
import 'package:places/home.dart';
import 'package:places/models/place.dart';
import '../models/tag_model.dart';

//Widgets
import '../widgets/Toast.dart';

//map helper
import '../helpers/location_helper.dart';

class Add_new_Place extends StatefulWidget {
  final double latitude;
  final double longtidue;

  Add_new_Place(this.latitude, this.longtidue);

  final maxSteps = 3;

  @override
  State<Add_new_Place> createState() => _Add_new_PlaceState();
}

class _Add_new_PlaceState extends State<Add_new_Place> {
  final _titleController = TextEditingController();
  List<TagData> tags = SearchTags.all;

  late File _pickedImage;
  bool onPressed = false;
  late FToast ftoast;
  int _currentStep = 0;
  LatLng newPosition = LatLng(0, 0);
  bool isTaped = false;
  //Id generator
  var uuid = Uuid();
  bool tagSelected = false;
  final placeTags =
      PlaceTag(false, false, false, false, false, false, false, false);
  bool resetTags = true;
  List<IconsData> iconList = [];
  //InitState
  @override
  void initState() {
    super.initState();
    ftoast = FToast();
    ftoast.init(context);
    tags.forEach((element) {
      element.isSelected = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    resetTags;
    tags;
    tags.forEach((element) {
      element.isSelected = false;
    });
  }

  void _selectLocation(LatLng position) {
    setState(() {
      newPosition = position;
      isTaped = true;
    });
  }

  void _selectImagine(File pickedImage) {
    _pickedImage = pickedImage;
  }

  final List<File> _gallery = [];

  List<File> get gallery {
    return [..._gallery];
  }

  final List<String> string_gallery = [];

  File? _storedImage;
  List<File> _storedList = [];
  bool isMap = false;

  void saveImage(File img) {
    setState(() {
      _gallery.insert(0, img);

      string_gallery.add(img.path);

      _currentStep = 1;
    });
  }

  Future<void> _takePictureFormGallery() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    setState(() {
      images!.forEach((element) {
        _storedList.add(File(element.path));
      });
    });

    final appDir = await sysPath.getApplicationDocumentsDirectory();

    _storedList.forEach((element) async {
      final fileName = path.basename(element.path);
      final savedImage =
          await File(element.path).copy("${appDir.path}/$fileName");

      saveImage(savedImage);
      _selectImagine(savedImage);
    });
    _storedList.clear();
  }

  Future<void> _takePicture(ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: source);

    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);

    final savedImage =
        await File(imageFile.path).copy("${appDir.path}/$fileName");
    saveImage(savedImage);

    _selectImagine(savedImage);
  }

  void saveBool() {
    setState(() {
      tags.forEach((element) {
        if (element.label == "Monument") {
          placeTags.monument = element.isSelected;
        } else if (element.label == "City") {
          placeTags.city = element.isSelected;
        } else if (element.label == "Experience") {
          placeTags.experience = element.isSelected;
        } else if (element.label == "Vacation") {
          placeTags.vacation = element.isSelected;
        } else if (element.label == "Work") {
          placeTags.work = element.isSelected;
        } else if (element.label == "Project") {
          placeTags.project = element.isSelected;
        } else if (element.label == "Personal") {
          placeTags.personal = element.isSelected;
        } else if (element.label == "Vista") {
          placeTags.vista = element.isSelected;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlacesProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0))),
        child: Column(
          children: [
            IconStepper(
              stepReachedAnimationEffect: Curves.easeIn,
              stepReachedAnimationDuration: const Duration(milliseconds: 200),
              activeStepBorderColor: Colors.transparent,
              lineDotRadius: 2,
              lineColor: Theme.of(context).colorScheme.primary,
              stepColor: Theme.of(context).colorScheme.tertiary,
              activeStepColor: Theme.of(context).colorScheme.primary,
              icons: [
                Icon(Icons.text_fields_outlined,
                    color: _currentStep == 0
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary),
                Icon(Icons.photo_album_outlined,
                    color: _currentStep == 1
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary),
                Icon(Icons.place_outlined,
                    color: _currentStep == 2
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary),
                Icon(
                  iconList.isEmpty
                      ? Icons.location_city
                      : IconData(iconList.first.codePoint,
                          fontFamily: iconList.first.fontFamily,
                          fontPackage: iconList.first.fontPackage,
                          matchTextDirection: iconList.first.textDirection),
                  color: _currentStep == 3
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                ),
              ],
              activeStep: _currentStep,
              onStepReached: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
            ),
            Expanded(child: itemInList()),
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
        onPressed: () {
          if (_currentStep < widget.maxSteps) {
            setState(() {
              _currentStep++;
            });
          }
        },
        child: Text("Next"));
  }

  Widget backButton() {
    return ElevatedButton(
        onPressed: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        child: Text("Back"));
  }

  Widget itemInList() {
    switch (_currentStep) {
      //Pictures
      case 1:
        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.447,
            width: double.infinity,
            child: GridView.builder(
                itemCount: _gallery.length + 2,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 3 / 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemBuilder: ((context, index) {
                  return GridTile(
                      child: index == 0
                          ? SizedBox.fromSize(
                              size: Size(70, 70), // button width and height
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Material(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentStep = 1;
                                      });
                                      _takePicture(ImageSource.camera);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.camera_alt,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            size: 35), // icon
                                        Text(
                                          "Photo",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                        ), // text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : index == 1
                              ? SizedBox.fromSize(
                                  size: const Size(
                                      70, 70), // button width and height
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      child: InkWell(
                                        onTap: () {
                                          print(_gallery.length);
                                          _takePictureFormGallery();
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.photo_album,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                size: 35), // icon
                                            Text(
                                              "Gallery",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ), // text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    child: Image.file(_gallery[index - 2],
                                        fit: BoxFit.fill),
                                    onLongPress: (() {
                                      setState(() {
                                        _gallery.removeWhere((element) =>
                                            element == _gallery[index - 2]);
                                        string_gallery.removeWhere((element) =>
                                            element ==
                                            _gallery[index - 2].path);
                                      });
                                    }),
                                    onTap: (() {
                                      showDialog(
                                          context: context,
                                          builder: (context) => _dialogBuilder(
                                              context, _gallery[index - 2]));
                                    }),
                                  ),
                                ));
                })),
          ),
        );
      //Google Map
      case 2:
        return Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.447,
                child: Stack(
                  children: [
                    GoogleMap(
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: isTaped
                            ? LatLng(
                                newPosition.latitude, newPosition.longitude)
                            : LatLng(widget.latitude, widget.longtidue),
                        zoom: 16,
                      ),
                      onTap: _selectLocation,
                      markers: {
                        Marker(markerId: MarkerId("m1"), position: newPosition)
                      },
                    ),
                  ],
                )),
          ),
        );
      //OverAll Final preview
      case 3:
        return Padding(
          padding: EdgeInsets.only(top: 10, left: 12, right: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentStep = 1;
                          });
                        },
                        child: Container(
                            color: Theme.of(context).colorScheme.primary,
                            height: 140,
                            width: 140,
                            child: gallery.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color:
                                              Color.fromRGBO(211, 206, 223, 1),
                                          size: 40,
                                        ),
                                        Text(
                                          "No Picture",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  211, 206, 223, 1),
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  )
                                : Image.file(
                                    File(gallery.first.path),
                                    fit: BoxFit.fill,
                                  )),
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (isTaped) {
                                return;
                              } else {
                                _currentStep = 2;
                              }
                            });
                          },
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                alignment: Alignment.topLeft,
                                height: 40,
                                width: 200,
                                child: isTaped
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          Text(
                                            "Location selected",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: "RobotoRegular",
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          )
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.location_off,
                                            size: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          Text("Location not selected",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary))
                                        ],
                                      )),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 20,
                              width: 200,
                              child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  addRepaintBoundaries: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              iconList.isEmpty ? 1 : 5),
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      iconList.isEmpty ? 1 : iconList.length,
                                  itemBuilder: ((context, index) {
                                    if (iconList.isEmpty) {
                                      return Builder(builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: GridTile(
                                            child: Text("No tag selected",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 20)),
                                          ),
                                        );
                                      });
                                    } else {
                                      return GridTile(
                                          child: Icon(
                                        IconData(iconList[index].codePoint,
                                            fontFamily:
                                                iconList[index].fontFamily,
                                            fontPackage:
                                                iconList[index].fontPackage,
                                            matchTextDirection:
                                                iconList[index].textDirection),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ));
                                    }
                                  }))),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        _titleController.text == ""
                            ? "Name your Place.."
                            : _titleController.text,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: "RobotoRegular",
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: (() async {
                          if (_titleController.text.isEmpty ||
                              _gallery.isEmpty ||
                              newPosition.latitude == 0 ||
                              newPosition.longitude == 0 ||
                              iconList.isEmpty) {
                            ftoast.showToast(
                                child: somethingGotWrong,
                                gravity: ToastGravity.TOP,
                                toastDuration: Duration(seconds: 2));
                            return;
                          }
                          final id = uuid.v4();
                          Provider.of<PlacesProvider>(context, listen: false)
                              .addPlace(
                                  _titleController.text,
                                  string_gallery,
                                  PlaceLocation(
                                      newPosition.latitude,
                                      newPosition.longitude,
                                      _titleController.text,
                                      id),
                                  id,
                                  placeTags,
                                  iconList);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => HomeScreen())));

                          ftoast.showToast(
                              child: toastJourneyAdded,
                              gravity: ToastGravity.CENTER,
                              toastDuration: Duration(seconds: 1));
                        }),
                        icon: const Icon(
                          Icons.location_city_outlined,
                          color: Color.fromRGBO(211, 206, 223, 1),
                        ),
                        label: const Text(
                          "Add a place",
                          style: TextStyle(
                              color: Color.fromRGBO(211, 206, 223, 1)),
                        )),
                  ),
                ),
              )
            ],
          ),
        );
      //Select Title
      default:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onSubmitted: ((value) {
                  FocusScope.of(context).unfocus();
                }),
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                    fontFamily: "RobotoRegular",
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    textBaseline: TextBaseline.alphabetic,
                    color: Color.fromRGBO(116, 141, 166, 1)),
                maxLength: 15,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(156, 180, 204, 1))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(156, 180, 204, 1))),
                  counterStyle:
                      TextStyle(color: Color.fromRGBO(116, 141, 166, 1)),
                  hintText: "Journey and Tag",
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(116, 141, 166, 1),
                      fontFamily: "RobotoRegular",
                      fontWeight: FontWeight.w500,
                      fontSize: 28),
                ),
                controller: _titleController,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Container(child: buildChips()),
            ),
          ],
        );
    }
  }

  Widget buildChips() => Wrap(
      runSpacing: 15,
      spacing: 15,
      children: tags
          .map((tag) => FilterChip(
                onSelected: (isSelected) => setState(() {
                  if (isSelected == true) {
                    iconList.add(IconsData(
                        tag.icon.icon!.codePoint,
                        tag.icon.icon!.fontFamily,
                        tag.icon.icon!.fontPackage,
                        tag.icon.icon!.matchTextDirection));
                  } else {
                    iconList.removeWhere((element) =>
                        element.codePoint == tag.icon.icon!.codePoint);
                  }
                  tag.isSelected = !tag.isSelected;
                  resetTags = false;
                  saveBool();
                }),
                checkmarkColor: Theme.of(context).colorScheme.primary,
                showCheckmark: (tag.isSelected ? true : false),
                selected: tag.isSelected,
                selectedColor: Theme.of(context).colorScheme.tertiary,
                avatar: (tag.isSelected ? null : tag.icon),
                label: Text(
                  tag.label,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ))
          .toList());
}

Widget _dialogBuilder(BuildContext context, File img) {
  return SimpleDialog(
    contentPadding: EdgeInsets.zero,
    children: [
      Image.file(
        img,
        fit: BoxFit.fill,
      ),
    ],
  );
}
