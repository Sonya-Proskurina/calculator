import 'package:flutter/material.dart';

class ButtonEntities {
  Color fon = Colors.white10;
  List<ButtonBodyEntities> buttons = [];
  bool firstOn = true;

  ButtonEntities.forColor({required this.fon, required this.buttons});

  ButtonEntities({required this.buttons});
}

class ButtonBodyEntities {
  String? name;
  IconData? iconData;
  String eventText;

  ButtonBodyEntities.forName({required this.name, required this.eventText});
  ButtonBodyEntities.forIcon({required this.eventText, required this.iconData});
}
