import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_units/category.dart';
import 'package:flutter_units/unit.dart';

import 'package:rxdart/rxdart.dart';

import 'currencyApi.dart';

class CategoryBloc {
  List<String> _names = <String>[
    "Length",
    "Area",
    "Volume",
    "Mass",
    "Time",
    "Digital Storage",
    "Energy",
    "Currency",
  ];

  List<IconData> _icons = <IconData>[
    Icons.straighten,
    Icons.tab_unselected,
    Icons.free_breakfast,
    Icons.shopping_basket,
    Icons.access_time,
    Icons.sd_storage,
    Icons.flash_on,
    Icons.attach_money,
  ];

  List<Color> _colors = <Color>[
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
    Colors.deepOrangeAccent,
    Colors.purpleAccent,
    Colors.amberAccent,
  ];

  List<Category> _categories = <Category>[];

  //inputs
  final _currentCatController = StreamController<Category>();
  Sink<Category> get currentCat => _currentCatController.sink;

  //output
  final _defaultCatSubject = BehaviorSubject<Category>();
  Stream<Category> get defaultCategory => _defaultCatSubject.stream;

  final _categoriesSubject = BehaviorSubject<List<Category>>();
  Stream<List<Category>> get categories => _categoriesSubject.stream;

  final _currentCatSubject = BehaviorSubject<Category>();
  Stream<Category> get currentCategory => _currentCatSubject.stream;

  CategoryBloc() {
    _getCategories();

    _categoriesSubject.add(_categories);

    _currentCatController.stream.listen((category){
      _currentCatSubject.sink.add(category);
    });
  }

  Future<void> _getCategories() async {
    final json = rootBundle.loadString('assets/data/regular_units.json');

    final data = JsonDecoder().convert(await json);

    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    for (int i = 0; i < _names.length - 1; i++) {
      _categories.add(Category.fromJson(
          parsedJson: data,
          colorJ: _colors[i],
          iconJ: _icons[i],
          nameJ: _names[i]));

      if (i == 0) {
        _defaultCatSubject.add(_categories[i]);
      }
    }

    await _getApiCategory();
  }

  Future<void> _getApiCategory() async {
    _categories.add(Category(
      color: _colors.last,
      icon: _icons.last,
      name: _names.last,
      units: [],
    ));

    final apiData = await CurrencyApi().getUnits('currency');

    if (apiData != null) {
      final units = <Unit>[];
      for (var unit in apiData) {
        units.add(Unit.fromJson(unit));
      }

      _categories.removeLast();
      _categories.add(Category(
        name: _names.last,
        units: units,
        color: _colors.last,
        icon: _icons.last,
      ));
    }
  }

  void dispose(){
    _currentCatController.close();
    _currentCatSubject.close();
  }
}
