import 'package:flutter/material.dart';
import 'unit.dart';

class Category{
  final Color color;
  final String name;
  final IconData icon;
  final List<Unit> units;

  Category({this.color, this.name, this.icon, this.units});
}