import 'package:flutter/material.dart';

class CharacterModel {
  final String id;
  final String name;
  final int cost;
  final Color bodyColor;
  final Color accentColor;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.bodyColor,
    required this.accentColor,
  });

  static const List<CharacterModel> all = [
    CharacterModel(
      id: 'sky',
      name: 'Sky',
      cost: 0,
      bodyColor: Color(0xFF4FC3F7),
      accentColor: Color(0xFFFFFFFF),
    ),
    CharacterModel(
      id: 'bolt',
      name: 'Bolt',
      cost: 100,
      bodyColor: Color(0xFFFFD54F),
      accentColor: Color(0xFFFF7043),
    ),
    CharacterModel(
      id: 'luna',
      name: 'Luna',
      cost: 250,
      bodyColor: Color(0xFFBA68C8),
      accentColor: Color(0xFFE1BEE7),
    ),
    CharacterModel(
      id: 'blaze',
      name: 'Blaze',
      cost: 500,
      bodyColor: Color(0xFFEF5350),
      accentColor: Color(0xFFFFCC80),
    ),
  ];

  static CharacterModel byId(String id) =>
      all.firstWhere((c) => c.id == id, orElse: () => all.first);
}
