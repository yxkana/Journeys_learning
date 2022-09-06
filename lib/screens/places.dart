import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../widgets/Boxes.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import '../providers/places_provider.dart';
import '../widgets/places_widget.dart';
import '../models/place.dart';
import '../data/tag_data.dart';
import '../models/tag_model.dart';
import 'dart:math';
import '../data/tags_data_falseModels.dart';
import './detail_place.dart';
import '../widgets/searchPlace_widget.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as insert;

class Places extends StatefulWidget {
  int searhnumber = 0;
  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> with SingleTickerProviderStateMixin {
  List<TagData> tags = Tags.all;
  bool onClick = false;
  bool showTags = false;
  bool searchBarTap = false;
  final FocusNode node1 = FocusNode();
  List<Place> tagPlace = [];
  List<Place> searchTag = [];
  List<Place> searchPlace = [];

  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  late Animation<Offset> _slideAnimationOfSearch;
  late Animation<double> _opacityAnimation;

  late TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(searchPlace.length);

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: 200)); //How long will take animation time to finish
    _slideAnimationOfSearch = Tween<Offset>(
            //Tween animation bettween two objects. Změnšovaní nebo zvětšovaní objectu.
            begin: Offset(-20, 0),
            end:
                Offset(0, 0)) //Here we store information required for animation
        .animate(CurvedAnimation(
            //Here we set what animation we use
            parent: _controller, //We set a Animation controller
            curve:
                Curves //How animation will be played (př.   liner - po celou dobu animace se rychlost animace nezmení)
                    .linear));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _slideAnimationOfSearch.addListener(() {
      setState(() {});
    });
  }

  void searchForTag(List<Place> Places) {
    final placeProvider = Provider.of<PlacesProvider>(context, listen: false);
    if (placeProvider.tagMap["Monument"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagMonument.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      } else {
        setState(() {
          tagPlace = tagPlace + placeProvider.tagMonument;
          List<Place> fLIst = tagPlace.toSet().toList();
          tagPlace = fLIst;
        });
      }
    }
    if (placeProvider.tagMap["Experience"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagExperience.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      }
      tagPlace = tagPlace + placeProvider.tagExperience;
      setState(() {
        List<Place> fLIst = tagPlace.toSet().toList();
        tagPlace = fLIst;
      });
    }
    if (placeProvider.tagMap["City"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagCity.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      }
      tagPlace = tagPlace + placeProvider.tagCity;
      setState(() {
        List<Place> fLIst = tagPlace.toSet().toList();
        tagPlace = fLIst;
      });
    }
    if (placeProvider.tagMap["Vacation"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagVacation.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      }
      tagPlace = tagPlace + placeProvider.tagVacation;
      setState(() {
        List<Place> fLIst = tagPlace.toSet().toList();
        tagPlace = fLIst;
      });
    }
    if (placeProvider.tagMap["Work"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagWork.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      }
      tagPlace = tagPlace + placeProvider.tagWork;
      setState(() {
        List<Place> fLIst = tagPlace.toSet().toList();
        tagPlace = fLIst;
      });
    }
    if (placeProvider.tagMap["Personal"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagPersonal.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      }
      tagPlace = tagPlace + placeProvider.tagPersonal;
      setState(() {
        List<Place> fLIst = tagPlace.toSet().toList();
        tagPlace = fLIst;
      });
    }
    if (placeProvider.tagMap["Project"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagProject.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      }
      tagPlace = tagPlace + placeProvider.tagProject;
      setState(() {
        List<Place> fLIst = tagPlace.toSet().toList();
        tagPlace = fLIst;
      });
    }
    if (placeProvider.tagMap["Vista"] == true) {
      if (textEditingController.text.isNotEmpty) {
        final searchList = placeProvider.tagVista.where((element) {
          final placeName = element.title.toLowerCase();
          final input = textEditingController.text.toLowerCase();

          return placeName.startsWith(input);
        }).toList();

        searchTag.addAll(searchList);
        setState(() {
          List<Place> fLIst = searchTag.toSet().toList();
          searchTag = fLIst;
        });
      }
      tagPlace = tagPlace + placeProvider.tagVista;
      setState(() {
        List<Place> fLIst = tagPlace.toSet().toList();
        tagPlace = fLIst;
      });
    }
    /* if (placeProvider.tagMap["Experience"] == false) {
      tagPlace.removeWhere((element) => element.tag!.experience == true);
    } */
    /* if (placeProvider.tagMap["Monument"] == false) {
      tagPlace.removeWhere((element) => element.tag!.monument == true);
    } */
  }

  void removeForTag(List<Place> Places) async {
    final placeProvider = Provider.of<PlacesProvider>(context, listen: false);

    if (placeProvider.tagMap["Monument"] == false) {
      tagPlace.clear();
      searchForTag(Places);
    }
    if (placeProvider.tagMap["City"] == false) {
      searchForTag(Places);
      tagPlace.clear();
    }
    if (placeProvider.tagMap["Experience"] == false) {
      searchForTag(Places);
      tagPlace.clear();
    }
    if (placeProvider.tagMap["Vacation"] == false) {
      tagPlace.clear();
      searchForTag(Places);
    }
    if (placeProvider.tagMap["Work"] == false) {
      tagPlace.clear();
      searchForTag(Places);
    }
    if (placeProvider.tagMap["Personal"] == false) {
      tagPlace.clear();
      searchForTag(Places);
    }
    if (placeProvider.tagMap["Project"] == false) {
      tagPlace.clear();
      searchForTag(Places);
    }
    if (placeProvider.tagMap["Vista"] == false) {
      tagPlace.clear();
      searchForTag(Places);
    }
  }

  void LookForPlace(
    String quary,
    List<Place> list,
  ) {
    if (Provider.of<PlacesProvider>(context, listen: false).tagPreserver ==
        true) {
      searchTag.clear();
      final sugestionTag = tagPlace.where((element) {
        final placeName = element.title.toLowerCase();
        final input = quary.toLowerCase();

        return placeName.startsWith(input);
      }).toList();
      setState(() {
        searchTag = sugestionTag;
      });
    } else {
      final sugestionTag = tagPlace.where((element) {
        final placeName = element.title.toLowerCase();
        final input = quary.toLowerCase();

        return placeName.startsWith(input);
      }).toList();
      setState(() {
        searchTag = sugestionTag;
      });

      final sugestion = list.where((element) {
        final placeName = element.title.toLowerCase();
        final input = quary.toLowerCase();

        return placeName.startsWith(input);
      }).toList();
      setState(() {
        searchPlace = sugestion;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Widget buildChips(List<Place> places) => Wrap(
      spacing: 10,
      children: tags
          .map(
            (tag) => Padding(
              padding: EdgeInsets.only(
                  left: tag.label == "Monument" ? 14 : 0,
                  right: tag.label == "Vista" ? 14 : 0),
              child: FilterChip(
                visualDensity: VisualDensity(vertical: 3, horizontal: 3),
                checkmarkColor: tag.isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.tertiary,
                onSelected: (isSelected) => setState(() {
                  tag.isSelected = !tag.isSelected;

                  Provider.of<PlacesProvider>(context, listen: false)
                      .tagMap
                      .update(tag.label, ((value) {
                    return tag.isSelected;
                  }));
                  if (Provider.of<PlacesProvider>(context, listen: false)
                      .tagMap
                      .containsValue(true)) {
                    Provider.of<PlacesProvider>(context, listen: false)
                        .tagPreserver = true;
                  } else {
                    Provider.of<PlacesProvider>(context, listen: false)
                        .tagPreserver = false;
                  }
                  if (tag.isSelected == false) {
                    removeForTag(places);
                    LookForPlace(textEditingController.text, places);
                  }
                  if (tag.isSelected == true) {
                    searchForTag(places);
                  }
                }),
                selected: tag.isSelected,
                selectedColor: Theme.of(context).colorScheme.tertiary,
                avatar: (tag.isSelected ? null : tag.icon),
                showCheckmark: (tag.isSelected ? true : false),
                elevation: 5,
                label: Text(
                  tag.label,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary),
                ),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          )
          .toList());

  void showItem(int number, String quary, Place place) {
    setState(() {
      onClick = true;
      widget.searhnumber = number;
      place.title.contains(quary);
    });
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlacesProvider>(context, listen: false);

    return KeyboardDismisser(
      gestures: [GestureType.onTap],
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: ValueListenableBuilder<Box<Place>>(
            valueListenable: Boxes.getPlace().listenable(),
            builder: (context, value, child) {
              var _places =
                  value.values.toList().reversed.cast<Place>().toList();
              placeProvider.listOfPlaces =
                  value.values.toList().reversed.cast<Place>().toList();

              return Container(
                  color: Theme.of(context).colorScheme.secondary,
                  height: MediaQuery.of(context).size.height * 1,
                  width: double.infinity,
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.06,
                            left: 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              color: Theme.of(context).colorScheme.secondary,
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          placeProvider.cancelsearch();
                                          setState(() {
                                            placeProvider.tagMap
                                                .forEach((key, value) {
                                              value = false;
                                            });
                                            tags.forEach((element) {
                                              element.isSelected = false;
                                            });
                                            tagPlace.clear();
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 22),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Journeys",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 36,
                                                  fontFamily: "RobotoRegular",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 22),
                                        child: IconButton(
                                            onPressed: () {
                                              showSearch(
                                                  context: context,
                                                  delegate: PlaceSearch(
                                                    _places,
                                                    widget.searhnumber,
                                                    onClick,
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.search,
                                              size: 36,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.035,
                                  ),
                                  /*  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.065,
                                      child: TextField(
                                        focusNode: node1,
                                        controller: textEditingController,
                                        onChanged: ((value) {
                                          LookForPlace(
                                              textEditingController.text,
                                              _places);
                                        }),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 20),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.search_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            hintText: "Find your Journey..",
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none),
                                      ),
                                    ),
                                  ) */

                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return buildChips(_places);
                                      },
                                      itemCount: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                    _places.isEmpty
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Save some nice place"),
                            ),
                          )
                        : Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Theme.of(context).backgroundColor),
                                  child: GridView.builder(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height *
                                              0.015,
                                          bottom: MediaQuery.of(context).size.height *
                                              0.08),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0,
                                              crossAxisCount: 2,
                                              childAspectRatio: 2.2 / 3),
                                      itemBuilder: (context, index) => textEditingController
                                                  .text.isNotEmpty &&
                                              (placeProvider.tagPreserver ==
                                                  true)
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5,
                                                  right: 5,
                                                  bottom: 10),
                                              child: PlacesGrid(searchTag[index], index, tagPlace))
                                          : textEditingController.text.isEmpty && (placeProvider.tagPreserver == true)
                                              ? Padding(padding: EdgeInsets.only(left: 5, right: 5, bottom: 10), child: PlacesGrid(tagPlace[index], index, tagPlace))
                                              : textEditingController.text.isNotEmpty && (placeProvider.tagPreserver == false)
                                                  ? Padding(padding: EdgeInsets.only(left: 5, right: 5, bottom: 10), child: PlacesGrid(searchPlace[index], index, tagPlace))
                                                  : placeProvider.tagPreserver == false
                                                      ? Padding(padding: EdgeInsets.only(left: 5, right: 5, bottom: 10), child: PlacesGrid(_places[index], index, tagPlace))
                                                      : Padding(padding: EdgeInsets.only(left: 5, right: 5, bottom: 10), child: PlacesGrid(tagPlace[index], index, tagPlace)),
                                      itemCount: textEditingController.text.isNotEmpty && placeProvider.tagPreserver
                                          ? searchTag.length
                                          : textEditingController.text.isEmpty && placeProvider.tagPreserver
                                              ? tagPlace.length
                                              : textEditingController.text.isNotEmpty && placeProvider.tagPreserver == false
                                                  ? searchPlace.length
                                                  : placeProvider.tagPreserver
                                                      ? tagPlace.length
                                                      : _places.length)),
                            ),
                          )
                  ]));
            },
          )),
    );
  }
}

class PlaceSearch extends SearchDelegate<String> {
  List<Place> _listPlaces;
  bool isTapped;

  int _searchNumber;

  PlaceSearch(
    this._listPlaces,
    this._searchNumber,
    this.isTapped,
  );

  List<Place> get searchedItem {
    return _listPlaces.where((element) {
      final finalTitle = element.title.toLowerCase();
      final input = query.toLowerCase();
      return finalTitle.startsWith(input);
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              isTapped = !isTapped;
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
        //Provider.of<PlacesProvider>(context, listen: false).cancelsearch();
        isTapped = !isTapped;
        close(context, "");
      },
      icon: Icon(Icons.arrow_back));
  @override
  Widget buildResults(
    BuildContext context,
  ) =>
      GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
              crossAxisCount: 2,
              childAspectRatio: 2.2 / 3),
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
                child: SearchGrid(
                    searchedItem[index], index, searchedItem, searchedItem));
          },
          itemCount: searchedItem.length);
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Place> suggestions = _listPlaces.where((element) {
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
        textInputAction;
        return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Detail_screen(
                          suggestions[index].id, _listPlaces[index])));
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
