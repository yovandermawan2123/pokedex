import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String, Color> pokemonColorPalette = {
  // Extracted from image
  'green': Color(0xFF59CFB3),
  'greenDark': Color(0xFF6E9179),
  'red': Color(0xFFF2756F),
  'blue': Color(0xFF8ECDE0),
  'white': Color(0xFFFCFCFC),
  'lightGray': Color(0xFFDFD9DA),

  // Adjusted pastel colors (selaras tone)
  'yellow': Color(0xFFFFE28A),
  'pink': Color(0xFFF4A6C8),
  'purple': Color(0xFFB9A6E5),
  'brown': Color(0xFFC8A98A),
  'black': Color(0xFF2B2B2B),
};

Color mapPokemonColor(String? colorName) {
  if (colorName != null && pokemonColorPalette.containsKey(colorName)) {
    return pokemonColorPalette[colorName]!;
  } else {
    return Colors.grey.shade300; // fallback
  }
}
