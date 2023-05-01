import 'dart:io';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Color primaryColor = Color.fromARGB(255, 221, 136, 240);
Color secondaryColor = Color.fromARGB(255, 241, 160, 233);
Color tertiaryColor = Color.fromARGB(255, 190, 176, 237);
Color grayColor = const Color.fromARGB(255, 50, 50, 51);

generateColor(image, {local = false}) async {
  if (local) {
    return await PaletteGenerator.fromImageProvider(
      Image.file(File(image)).image,
    );
  }
  PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
    Image.network(image).image,
  );
  return paletteGenerator;
}

Color? lighten(Color? color, [double amount = 0.2]) {
  assert(amount >= 0 && amount <= 1);
  if (color == null) return color;
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
