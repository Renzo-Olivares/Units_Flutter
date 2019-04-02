import 'package:flutter/material.dart';
import 'unit.dart';

class Category {
  final Color color;
  final String name;
  final IconData icon;
  final List<Unit> units;

  Category({this.color, this.name, this.icon, this.units});

  //create from json
  factory Category.fromJson(
      {Map<String, dynamic> parsedJson,
      Color colorJ,
      IconData iconJ,
      String nameJ}) {
    List<Unit> unitsJ;

    unitsJ = parsedJson['$nameJ']
        .map<Unit>((dynamic parsedJson) => Unit.fromJson(parsedJson))
        .toList();

    return Category(
      name: nameJ,
      color: colorJ,
      icon: iconJ,
      units: unitsJ,
    );
  }
}
