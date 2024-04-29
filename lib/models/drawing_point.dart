import 'package:flutter/material.dart';
import 'package:stenofied/utils/color_util.dart';

class DrawingPoint {
  int id;
  List<Offset> offsets;
  Color color;
  double width;

  DrawingPoint(
      {this.id = 1,
      this.offsets = const [],
      this.color = CustomColors.ketchup,
      this.width = 4});

  DrawingPoint copyWith({List<Offset>? offsets}) {
    return DrawingPoint(
        id: id, color: color, width: width, offsets: offsets ?? this.offsets);
  }
}
