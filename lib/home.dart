import 'package:flutter/material.dart';

import './helpers/custom_slider_right.dart';
import './screens/places.dart';
import './screens/map.dart';



import 'package:animations/animations.dart';
import './widgets/add_place_new.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentTab = 0;
  int _preveusTab = 0;
  Offset offset = Offset(0, 0);

  bool tab0 = true;
  bool tab1 = true;
  bool tab2 = true;
  bool tab3 = true;

  late AnimationController _controller0;
  late AnimationController _controller1;

  late Animation<double> _popUpAnimationSize0;
  late Animation<double> _popUpAnimationSize1;

  late AnimationController _slideController0;
  late AnimationController _slideController1;

  late Animation<Offset> _iconSlideAnimation0;
  late Animation<Offset> _iconSlideAnimation1;

  late Animation<double> _iconFadeAnimation0;
  late Animation<double> _iconFadeAnimation1;

  final List<Widget> screens = [
    Places(),
    MapScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller0 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _slideController0 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _slideController1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _iconSlideAnimation0 =
        Tween<Offset>(begin: Offset(-0.5, 0), end: Offset(-0.2, 0)).animate(
            CurvedAnimation(parent: _slideController0, curve: Curves.linear));

    _iconSlideAnimation1 =
        Tween<Offset>(begin: Offset(-0.2, 0), end: Offset(-0.4, 0)).animate(
            CurvedAnimation(parent: _slideController1, curve: Curves.linear));

    _iconFadeAnimation0 = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _slideController0, curve: Curves.linear));

    _iconFadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _slideController1, curve: Curves.linear));

    _popUpAnimationSize0 = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(tween: Tween<double>(begin: 37, end: 27), weight: 100),
    ]).animate(CurvedAnimation(parent: _controller0, curve: Curves.easeIn));
    _popUpAnimationSize1 = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(tween: Tween<double>(begin: 27, end: 37), weight: 100),
    ]).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeIn));

    _popUpAnimationSize0.addListener(() {
      setState(() {});
    });
    _popUpAnimationSize1.addListener(() {
      setState(() {});
    });
  }

  appBarTransationHelper() {
    if (currentTab == 0 && _preveusTab == 0) {
      setState(() {
        offset = Offset(-1.5, 0);
      });
    } else if (currentTab == 1 && _preveusTab == 0) {
      setState(() {
        offset = Offset(-1.5, 0);
      });
    } else if (currentTab == 2 && _preveusTab == 0) {
      setState(() {
        offset = Offset(-1.5, 0);
      });
    } else if (currentTab == 3 && _preveusTab == 0) {
      setState(() {
        offset = Offset(-1.5, 0);
      });
    }
    if (currentTab == 0 && _preveusTab == 1) {
      setState(() {
        offset = Offset(1.5, 0);
      });
    } else if (currentTab == 0 && _preveusTab == 2) {
      setState(() {
        offset = Offset(1.5, 0);
      });
    } else if (currentTab == 0 && _preveusTab == 3) {
      setState(() {
        offset = Offset(1.5, 0);
      });
    }
    if (currentTab == 1 && _preveusTab == 2) {
      setState(() {
        offset = Offset(1.5, 0);
      });
    } else if (currentTab == 1 && _preveusTab == 3) {
      setState(() {
        offset = Offset(1.5, 0);
      });
    }
    if (currentTab == 2 && _preveusTab == 3) {
      setState(() {
        offset = Offset(1.5, 0);
      });
    } else if (currentTab == 2 && _preveusTab == 1) {
      setState(() {
        offset = Offset(-1.5, 0);
      });
    }
    if (currentTab == 3 && _preveusTab == 1) {
      setState(() {
        offset = Offset(1.5, 0);
      });
    }
    if (currentTab == 3 && _preveusTab == 2) {
      setState(() {
        offset = Offset(-1.5, 0);
      });
    }
  }

  void preveusTab() {
    setState(() {
      _preveusTab = currentTab;
    });
  }

  appBarAnimationHelper() {
    if (tab0 == false) {
      setState(() {
        _controller0.forward();
      });
    }
    if (tab1 == false) {
      setState(() {
        _controller1.reverse();
      });
    }
  }

  Offset arrow() {
    return Offset(1.5, 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller0.dispose();
    _controller1.dispose();
  }

  final PageStorageBucket bucket = PageStorageBucket();

  Widget currentScreen = Places();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageTransitionSwitcher(
          duration: Duration(milliseconds: 270),
          transitionBuilder: ((child, primaryAnimation, secondaryAnimation) =>
              SlideTransition(
                position: Tween<Offset>(begin: offset, end: Offset.zero)
                    .animate(primaryAnimation),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 1, end: 0.0)
                      .animate(secondaryAnimation),
                  child: child,
                ),
              )),
          child: screens[currentTab]),
      floatingActionButton: FloatingActionButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        heroTag: "fab",
        elevation: 10,
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 239, 217, 219),
        ),
        onPressed: () async {
          await Location().getLocation().then((value) => showModalBottomSheet(
              backgroundColor: Colors.transparent,
              enableDrag: false,
              context: context,
              builder: (context) {
                return Add_new_Place(value.latitude!, value.longitude!);
              }));

          //Navigator.pushNamed(context, AddScreen.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 40,
        color: Theme.of(context).colorScheme.secondary,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.none,
        child: Container(
          height: 60,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _controller0,
                        builder: (BuildContext context, _) {
                          return MaterialButton(
                            minWidth: 90,
                            onPressed: () async {
                              await Future((() {
                                _slideController0.reverse();
                                _slideController1.reverse();
                                preveusTab();
                                setState(() {
                                  currentTab = 0;
                                  tab1 = false;
                                });
                              })).then(
                                (value) {
                                  appBarTransationHelper();
                                  currentScreen = Places();
                                },
                              ).then(
                                (value) {
                                  appBarAnimationHelper();
                                  _controller0.reverse();

                                  print(_preveusTab);
                                },
                              );
                            },
                            child: Row(
                              children: [
                                SlideTransition(
                                  position: _iconSlideAnimation0,
                                  child: Icon(
                                    Icons.book,
                                    size: _popUpAnimationSize0.value,
                                    color: currentTab == 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                  ),
                                ),
                                FadeTransition(
                                  opacity: _iconFadeAnimation0,
                                  child: SlideTransition(
                                      position: _iconSlideAnimation1,
                                      child: Text("Journeys",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 18))),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _controller1,
                        builder: (BuildContext context, _) {
                          return MaterialButton(
                            minWidth: 90,
                            onPressed: () async {
                              _slideController0.forward();
                              _slideController1.forward();
                              preveusTab();
                              await Future((() {
                                currentTab = 1;
                                tab0 = false;
                              })).then(
                                (value) {
                                  appBarTransationHelper();
                                  currentScreen = MapScreen();
                                },
                              ).then(
                                (value) {
                                  appBarAnimationHelper();
                                  _controller1.forward();

                                  print(_preveusTab);
                                },
                              );
                            },
                            child: Row(
                              children: [
                                SlideTransition(
                                  position: _iconSlideAnimation1,
                                  child: Icon(
                                    Icons.map,
                                    size: _popUpAnimationSize1.value,
                                    color: currentTab == 1
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                  ),
                                ),
                                FadeTransition(
                                  opacity: _iconFadeAnimation1,
                                  child: SlideTransition(
                                      position: _iconSlideAnimation0,
                                      child: Text("Map",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 18))),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ]),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
