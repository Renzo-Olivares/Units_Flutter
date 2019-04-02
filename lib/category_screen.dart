import 'package:flutter/material.dart';
import 'backdrop_widget.dart';
import 'converter_screen.dart';
import 'category.dart';
import 'category_tile.dart';

class CategoryRoute extends StatefulWidget {
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

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;

  List<Category> _categories = <Category>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget._names.length; i++) {
      _categories.add(Category(
          name: widget._names[i],
          color: widget._colors[i],
          icon: widget._icons[i]));
      if (i == 0) {
        _defaultCategory = _categories[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          }, itemCount: _categories.length,);
    }
  }
}
