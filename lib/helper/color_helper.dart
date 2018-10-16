import 'dart:math';
import 'dart:ui';

class ColorHelper {
  static Color getRandomColor() {
    final int r = Random().nextInt(255);
    final int g = Random().nextInt(255);
    final int b = Random().nextInt(255);
    return Color.fromARGB(255, r, g, b);
  }
}
