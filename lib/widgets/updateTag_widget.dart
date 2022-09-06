import 'package:flutter/material.dart';
import '../models/tag_model.dart';
import '../data/tag_data.dart';
import '../providers/places_provider.dart';
import 'package:provider/provider.dart';
import '../screens/detail_place.dart';

import '../models/place.dart';

class updatetTag extends StatefulWidget {
  final Map<String, bool> tagMap;
  Place place;
  final Function _refresh;

  updatetTag(this.tagMap, this.place, this._refresh);

  @override
  State<updatetTag> createState() => _updatetTagState();
}

class _updatetTagState extends State<updatetTag> {
  List<TagData> tags = SearchTags.all;
  List<IconsData> _iconList = [];
  bool resetTags = true;
  final placeTags =
      PlaceTag(false, false, false, false, false, false, false, false);

  Map<String, bool> _tagMap = {};

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
  void initState() {
    // TODO: implement initState
    super.initState();

    tags.forEach((element) {
      widget.tagMap.forEach((key, value) {
        if (key == element.label) {
          setState(() {
            element.isSelected = value;
          });
        }
      });
    });
    _iconList = widget.place.listIcons;
    _tagMap = widget.tagMap;
  }

  Widget buildChips() => Wrap(
      runSpacing: 15,
      spacing: 15,
      children: tags
          .map((tag) => FilterChip(
                onSelected: (isSelected) => setState(() {
                  if (isSelected == true) {
                    if (widget.tagMap.containsKey(tag.label)) {
                      setState(() {
                        _tagMap.update(tag.label, (value) => value = true);
                        print(_tagMap);
                      });
                    }
                    _iconList.add(IconsData(
                        tag.icon.icon!.codePoint,
                        tag.icon.icon!.fontFamily,
                        tag.icon.icon!.fontPackage,
                        tag.icon.icon!.matchTextDirection));
                  } else {
                    if (widget.tagMap.containsKey(tag.label)) {
                      setState(() {
                        _tagMap.update(tag.label, (value) => value = false);
                      });
                    }
                    _iconList.removeWhere((element) =>
                        element.codePoint == tag.icon.icon!.codePoint);
                  }
                  tag.isSelected = !tag.isSelected;
                  resetTags = false;
                  saveBool();
                }),
                showCheckmark: (tag.isSelected ? true : false),
                checkmarkColor: Theme.of(context).colorScheme.primary,
                selected: tag.isSelected,
                selectedColor: Theme.of(context).colorScheme.tertiary,
                avatar: (tag.isSelected ? null : tag.icon),
                label: Text(tag.label),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ))
          .toList());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
            child: GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child:
                      Padding(padding: EdgeInsets.all(20), child: buildChips()),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.secondary),
                ),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        Provider.of<PlacesProvider>(context, listen: false)
                            .updateTag(
                                widget.place, _tagMap, placeTags, _iconList);
                        widget._refresh();
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Save"))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
