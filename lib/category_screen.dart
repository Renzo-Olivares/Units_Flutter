import 'package:flutter/material.dart';
import 'backdrop_widget.dart';
import 'converter_screen.dart';
import 'category.dart';
import 'category_tile.dart';
import 'dart:async';
import 'dart:convert';
import 'currencyApi.dart';
import 'unit.dart';

class CategoryRoute extends StatefulWidget {
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

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;

  List<Category> _categories = <Category>[];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if (_categories.isEmpty) {
      await _getLocalCategories();
      await _getApiCategory();
    }
  }

  Future<void> _getLocalCategories() async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');

    final data = JsonDecoder().convert(await json);

    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    setState(() {
      for (int i = 0; i < widget._names.length - 1; i++) {
        _categories.add(Category.fromJson(
            parsedJson: data,
            colorJ: widget._colors[i],
            iconJ: widget._icons[i],
            nameJ: widget._names[i]));

        if (i == 0) {
          _defaultCategory = _categories[i];
        }
      }
    });
  }

  Future<void> _getApiCategory() async{
    setState(() {
      _categories.add(
          Category(
            color: widget._colors.last,
            icon: widget._icons.last,
            name: widget._names.last,
            units: [],
          )
      );
    });

    final apiData = await currencyApi().getUnits('currency');

    if(apiData != null){
      final units = <Unit>[];
      for(var unit in apiData){
        units.add(Unit.fromJson(unit));
      }

      setState(() {
        _categories.removeLast();
        _categories.add(
          Category(
            name: widget._names.last,
            units: units,
            color: widget._colors.last,
            icon: widget._icons.last,
          )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    // TODO: implement build
    return Backdrop(
      currentCategory:
          _currentCategory == null ? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory == null
          ? ConverterScreen(category: _defaultCategory)
          : ConverterScreen(category: _currentCategory),
      backPanel: _buildCategoryScreen(MediaQuery.of(context).orientation),
      frontTitle: Text(
        'Unit Converter',
        style: TextStyle(fontSize: 27.0, color: Colors.black),
      ),
      backTitle: Text(
        'Select a Category',
        style: TextStyle(fontSize: 27.0, color: Colors.black),
      ),
    );
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildCategoryScreen(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 3.0),
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    }
  }
}
