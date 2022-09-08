import 'package:flutter/material.dart';

class TagData {
  final String label;
  final Color backgroundColor;
  final Icon icon;
  final Size size;
  late bool isSelected;

  TagData(
      this.label, this.backgroundColor, this.icon, this.size, this.isSelected);
}
