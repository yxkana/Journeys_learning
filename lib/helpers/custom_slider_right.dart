import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({required this.child, this.direction = AxisDirection.right})
      : super(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animatin, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero)
            .animate(animation),
        child: child,
      );

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.left:
        return Offset(1, 0);
      case AxisDirection.right:
        return Offset(-1, 0);
      case AxisDirection.down:
        return Offset(0, -1);
      case AxisDirection.up:
        return Offset(0, 1);
    }
  }
}
