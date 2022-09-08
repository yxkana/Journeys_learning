import 'package:flutter/material.dart';
import 'dart:io';
import '../helpers/button_hero_transition.dart';

//Home
import 'package:places/home.dart';

//Dependencies
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

//Widgets
import '../widgets/updateTag_widget.dart';
import '../widgets/grid_photo_widget.dart';

//Screens
import './update_map_screen.dart';

//Providers
import 'package:places/providers/places_provider.dart';
import 'package:places/widgets/toast.dart';
import 'package:provider/provider.dart';
import '../widgets/Boxes.dart';
import '../models/place.dart';

class Detail_screen extends StatefulWidget {
  static const routeName = "/detail-screen";
  final String id;
  final Place place;

  Detail_screen(this.id, this.place);

  @override
  State<Detail_screen> createState() => _Detail_screenState();
}

class _Detail_screenState extends State<Detail_screen>
    with TickerProviderStateMixin {
  List<File> gallery = [];
  final _placesBox = Boxes.getPlace();
  bool isSelectedForDelete = false;

  late FToast ftoast;

  final TextEditingController _controller = TextEditingController();
  List<String> listForDeletion = [];
  bool _isPressedDeleteActive = false;
  bool showDeleteAppBar = false;

  late Animation<Offset> _slideAnimationDeleteAppBar;
  late AnimationController _controllerDeleteAppBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ftoast = FToast();
    ftoast.init(context);
    _controller.text = widget.place.title;
    _controllerDeleteAppBar = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _slideAnimationDeleteAppBar =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _controllerDeleteAppBar, curve: Curves.linear));
  }

  unDeleteItem(String img) {
    setState(() {
      listForDeletion.remove(img);
      if (listForDeletion.isEmpty) {
        setState(() {
          isSelectedForDelete = false;
        });
        _controllerDeleteAppBar.reverse();
      }
    });
  }

  addDeleteItem(String img) {
    setState(() {
      //listForDeletion.add(imgString);

      setState(() {
        isSelectedForDelete = true;
        listForDeletion.add(img);
        if (listForDeletion.length == 1) {
          _controllerDeleteAppBar.forward();
        }
      });
    });
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuEntry> popUpmenuList = [
      PopupMenuItem(
          child: ListTile(
        title: const Text("Take Photo"),
        onTap: () async {
          final picker = ImagePicker();
          Navigator.pop(context);
          final imageFile = await picker.pickImage(source: ImageSource.camera);

          if (imageFile == null) {
            return;
          }

          final appDir = await sysPath.getApplicationDocumentsDirectory();
          final fileName = path.basename(imageFile.path);

          final savedImage =
              await File(imageFile.path).copy("${appDir.path}/$fileName");

          setState(() {
            Provider.of<PlacesProvider>(context, listen: false)
                .updatePlacePhoto(savedImage.path, widget.place);
          });
        },
      )),
      PopupMenuItem(
          child: ListTile(
        title: const Text("Add Photo"),
        onTap: () async {
          final picker = ImagePicker();
          Navigator.pop(context);
          final List<XFile>? images = await picker.pickMultiImage();
          final List<File> _storedList = [];
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

            setState(() {
              Provider.of<PlacesProvider>(context, listen: false)
                  .updatePlacePhoto(savedImage.path, widget.place);
            });
          });
          _storedList.clear();
        },
      )),
      PopupMenuItem(
          child: ListTile(
        title: const Text("Delete"),
        onTap: () async {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    content: const Text("Do you want to remove this Place ?"),
                    actions: [
                      TextButton(
                          onPressed: (() async {
                            await widget.place.delete();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen();
                              },
                            ));
                            ftoast.showToast(
                                child: JourneyDeleted,
                                gravity: ToastGravity.CENTER,
                                toastDuration: Duration(seconds: 1));
                          }),
                          child: const Text("Yes")),
                      TextButton(
                          onPressed: (() => Navigator.of(context).pop()),
                          child: const Text("No"))
                    ],
                  ));
        },
      )),
      PopupMenuItem(
          child: ListTile(
        title: const Text("Update map"),
        onTap: () async {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Updatemap(widget.place.location!.latitude,
                  widget.place.location!.longitude, widget.place)));
        },
      )),
      PopupMenuItem(
          child: ListTile(
        title: const Text("Change name"),
        onTap: () {
          Navigator.pop(context);
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text(
                          "Rename your Journey",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 40,
                            right: 40,
                          ),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.tertiary),
                            child: TextField(
                              onChanged: (value) {
                                value = _controller.text;
                              },
                              autofocus: true,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20),
                              controller: _controller,
                              decoration: const InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 40,
                              right: 40,
                              top: MediaQuery.of(context).size.height * 0.02,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Back"),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(140, 45),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(25)))),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      Provider.of<PlacesProvider>(context,
                                              listen: false)
                                          .updateTitle(
                                              _controller.text, widget.place);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Change"),
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(140, 45),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  25))))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      )),
    ];
    final _places = _placesBox.values
        .toList()
        .firstWhere((element) => element.id == widget.id);

    return Scaffold(
      bottomNavigationBar: SlideTransition(
        position: _slideAnimationDeleteAppBar,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomAppBar(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Photos selected: " + listForDeletion.length.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 22),
                    ),
                    IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  content: const Text("Are you sure"),
                                  actions: [
                                    TextButton(
                                        onPressed: (() async {
                                          _controllerDeleteAppBar.reverse();

                                          setState(() {
                                            Provider.of<PlacesProvider>(context,
                                                    listen: false)
                                                .deletePhotos(widget.place,
                                                    listForDeletion);
                                            listForDeletion.clear();
                                            isSelectedForDelete = false;
                                          });
                                          Navigator.pop(context);
                                        }),
                                        child: const Text("Yes")),
                                    TextButton(
                                        onPressed: (() =>
                                            Navigator.of(context).pop()),
                                        child: const Text("No"))
                                  ],
                                );
                              }));
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 175, 197, 226),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          isSelectedForDelete == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          int count = 0;
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    PopupMenuButton(
                      onSelected: ((value) {
                        PopupMenuCanceled;
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      itemBuilder: (context) {
                        return popUpmenuList;
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSelectedForDelete = false;
                          _controllerDeleteAppBar.reverse();
                          listForDeletion.clear();
                        });
                      },
                      icon: const Icon(Icons.close),
                      iconSize: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      "Click to go back",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    _places.title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            child: Row(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 1,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _places.listIcons.length + 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 40, crossAxisCount: 1),
                        itemBuilder: ((context, index) {
                          if (index < _places.listIcons.length) {
                            return Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: GridTile(
                                child: Icon(
                                  IconData(_places.listIcons[index].codePoint,
                                      fontFamily:
                                          _places.listIcons[index].fontFamily,
                                      fontPackage:
                                          _places.listIcons[index].fontPackage,
                                      matchTextDirection: _places
                                          .listIcons[index].textDirection),
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          }
                          return Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Hero(
                                tag: "tag_update",
                                child: IconButton(
                                  splashColor:
                                      Theme.of(context).colorScheme.secondary,
                                  splashRadius: 1,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.of(context).push(
                                          HeroDialogRoute(builder: ((context) {
                                        return updatetTag(
                                            widget.place.tagsOfPlaces,
                                            widget.place,
                                            refresh);
                                      })));
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 37,
                                  ),
                                ),
                              ));
                        })))
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: GridView.builder(
                      itemCount: _places.gallery.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0),
                      itemBuilder: (context, index) {
                        final gridPlace = _places.gallery[index];
                        final tag = StringBuffer();
                        tag.writeAll([widget.id, index]);
                        int number = 0;

                        return Photo_grid(
                            index,
                            widget.place,
                            refresh,
                            addDeleteItem,
                            unDeleteItem,
                            listForDeletion,
                            isSelectedForDelete);
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
