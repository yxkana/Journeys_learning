import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:places/models/place.dart';
import 'package:photo_view/photo_view.dart';
import 'package:places/providers/places_provider.dart';
import 'package:provider/provider.dart';

class displeyd_photo extends StatefulWidget {
  final String gridPlace;
  final List<String> _gallery;
  final String _id;
  int index;
  final Place _place;
  final Function _function;

  displeyd_photo(this._gallery, this._id, this.index, this.gridPlace,
      this._place, this._function);

  @override
  State<displeyd_photo> createState() => _displeyd_photoState();
}

class _displeyd_photoState extends State<displeyd_photo>
    with SingleTickerProviderStateMixin {
  String tag = "";
  int _currentIndex = 0;

  bool initialPageHandler = false;

  callBack(varIndex) {
    setState(() {
      print(varIndex);
      widget.index = varIndex;
      _currentIndex = varIndex;

      print(widget.index);
    });
  }

  //Curasel Animation
  late AnimationController _animationController;
  late Animation<double> _animation;
  late CarouselController _carouselController = CarouselController();
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _carouselController = CarouselController();
    _pageController = PageController(initialPage: widget.index);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    _animation = Tween(begin: 1.0, end: 1.17).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _currentIndex = widget.index;
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final tag = new StringBuffer();
    tag.writeAll(["pogo", widget.index]);

    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
              onPageChanged: (index) {
                _carouselController.animateToPage(index);
                _currentIndex = index;
                print(_currentIndex.toString() + " gallery_current index");
              },
              pageController: _pageController,
              itemCount: widget._gallery.length,
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              builder: ((context, index) {
                return PhotoViewGalleryPageOptions(
                    heroAttributes: PhotoViewHeroAttributes(
                        tag: index == 0
                            ? widget.gridPlace + widget._id + index.toString()
                            : widget._id + index.toString()),
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: FileImage(
                      File(widget._gallery[index]),
                    ));
              })),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 40),
                child: IconButton(
                  onPressed: () {
                    widget._function();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10, top: 40),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        Provider.of<PlacesProvider>(context, listen: false)
                            .deletePhoto(widget._place, _currentIndex);
                      });
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * .02),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemBuilder: (context, index, realIndex) =>
                      index == _currentIndex
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: ScaleTransition(
                                scale: _animation,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0)),
                                  child: Image.file(
                                    File(widget._gallery[index]),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                print(index);
                                _pageController.jumpToPage(index);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0)),
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.file(
                                          File(widget._gallery[index])))),
                            ),
                  itemCount: widget._gallery.length,
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * .1,
                      pageSnapping: true,
                      viewportFraction: 0.1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                          print(_currentIndex.toString() + " _currentIndex");
                          print(index.toString() + " _index");
                          _animationController.forward();
                        });
                      },
                      initialPage: widget.index,
                      enableInfiniteScroll: false),
                )),
          ),
        ],
      ),
    );
  }
}
