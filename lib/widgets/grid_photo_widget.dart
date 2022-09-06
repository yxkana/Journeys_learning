import 'package:flutter/material.dart';
import '../models/place.dart';
import 'dart:io';
import '../screens/dipley_photo.dart';

class Photo_grid extends StatefulWidget {
  final int _index;
  final Place _place;
  final Function _function;
  final Function _deleteItems;

  final Function _unDeleteItems;
  final List<String> _listOfDeletedItems;
  final bool _isDeleteAcitve;

  Photo_grid(this._index, this._place, this._function, this._deleteItems,
      this._unDeleteItems, this._listOfDeletedItems, this._isDeleteAcitve);

  @override
  State<Photo_grid> createState() => _Photo_gridState();
}

class _Photo_gridState extends State<Photo_grid> {
  isDeleteActive() {
    if (widget._isDeleteAcitve == false) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    isDeleteActive();
    final gridPlace = widget._place.gallery[widget._index];
    final tag = new StringBuffer();
    tag.writeAll([widget._place.id, widget._index]);
    return Hero(
        tag: widget._index == 0
            ? gridPlace + widget._place.id + widget._index.toString()
            : widget._place.id + widget._index.toString(),
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child: GestureDetector(
            onLongPress: () {
              if (widget._listOfDeletedItems.contains(gridPlace)) {
                widget._unDeleteItems(gridPlace);
              } else {
                widget._deleteItems(gridPlace);
              }

              setState(() {
                _isPressed = !_isPressed;
              });
            },
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return displeyd_photo(widget._place.gallery, widget._place.id,
                    widget._index, gridPlace, widget._place, widget._function);
              })));
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                _isPressed ? Colors.green : Colors.transparent,
                            width: _isPressed ? 3 : 0),
                        borderRadius: BorderRadius.circular(10)),
                    child: GridTile(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.file(
                        File(gridPlace),
                        fit: BoxFit.cover,
                        isAntiAlias: true,
                      ),
                    )),
                  ),
                ),
                _isPressed == true
                    ? Padding(
                        padding: EdgeInsets.all(3),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              color: Color.fromARGB(255, 59, 181, 63),
                            )),
                      )
                    : Container()
              ],
            ),
          ),
        ));
  }
}
