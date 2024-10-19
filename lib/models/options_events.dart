import 'package:flutter/material.dart';

//Custom Item for the PopupMenuItem:
class EventOption {
  final String name;
  final IconData icon;
  bool selected;

  EventOption({
    required this.name,
    required this.icon,
    this.selected = false,
  });
}
