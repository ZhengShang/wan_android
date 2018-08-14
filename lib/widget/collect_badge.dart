import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CollectBadge extends CustomPainter {
  final String label;

  CollectBadge(this.label) {
    _tp = TextPainter(text: TextSpan(text: label));
  }

  final Paint _paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;

  TextPainter _tp;

  Path _path;

  final _raidus = 20;
  final _pathWidth = 10;

  @override
  void paint(Canvas canvas, Size size) {
    if (_path == null) {
      _path = Path();
      _path.moveTo(size.width - _raidus, size.height);
      _path.lineTo(size.width, size.height - _raidus);
      _path.lineTo(size.width, size.height - _raidus - _pathWidth);
      _path.lineTo(size.width - _raidus - _pathWidth, size.height);
      _path.close();
    }

    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
