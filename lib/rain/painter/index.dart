import 'package:flutter/material.dart';
import 'package:portfolio/rain/model/index.dart';
import 'dart:ui' as ui;

class RainPainter extends CustomPainter {
  List<Raindrop> raindrops;
  ui.Image? image;

  RainPainter(this.raindrops, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    // print('${raindrops.firstOrNull?.x} : ${raindrops.firstOrNull?.y} : ${raindrops.firstOrNull?.ySpeed}');
    raindrops.forEach((raindrop) {
      // canvas.drawCircle(Offset(raindrop.x, raindrop.y), 2, paint);
      // canvas.drawRect(Rect.fromLTWH(raindrop.x, raindrop.y, 3, 10), paint);

      if (image != null) {
        canvas.drawImage(image!, Offset(raindrop.x, raindrop.y), paint);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
