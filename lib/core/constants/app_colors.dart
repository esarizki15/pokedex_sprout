import 'package:flutter/material.dart';

class AppColors {
  static Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return const Color(0xFF48D0B0);
      case 'fire':
        return const Color(0xFFFB6C6C);
      case 'water':
        return const Color(0xFF76BDFE);
      case 'electric':
        return const Color(0xFFFFCE4B);
      case 'poison':
        return const Color(0xFFA33EA1);
      case 'bug':
        return const Color(0xFFA6B91A);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'normal':
        return const Color(0xFFA8A77A);
      case 'ground':
        return const Color(0xFFE2BF65);
      case 'fairy':
        return const Color(0xFFD685AD);
      case 'psychic':
        return const Color(0xFFF95587);
      case 'fighting':
        return const Color(0xFFC22E28);
      case 'rock':
        return const Color(0xFFB6A136);
      case 'ghost':
        return const Color(0xFF735797);
      case 'ice':
        return const Color(0xFF96D9D6);
      case 'dragon':
        return const Color(0xFF6F35FC);
      default:
        return const Color(0xFF777777);
    }
  }
}
