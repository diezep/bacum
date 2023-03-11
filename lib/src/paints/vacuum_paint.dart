import 'dart:ui';

import 'package:flutter/material.dart';

class VacuumPaint implements Paint {
  @override
  BlendMode blendMode = BlendMode.srcOver;

  @override
  Color color = Colors.black;

  @override
  ColorFilter? colorFilter;

  @override
  FilterQuality filterQuality = FilterQuality.none;

  @override
  ImageFilter? imageFilter;

  @override
  bool invertColors = false;

  @override
  bool isAntiAlias = true;

  @override
  MaskFilter? maskFilter;

  @override
  Shader? shader;

  @override
  StrokeCap strokeCap = StrokeCap.butt;

  @override
  StrokeJoin strokeJoin = StrokeJoin.miter;

  @override
  double strokeMiterLimit = 4;

  @override
  double strokeWidth = 1;

  @override
  PaintingStyle style = PaintingStyle.fill;
}
