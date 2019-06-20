import 'package:flutter/material.dart';
import 'package:flutter_units/categoryProvider.dart';
import 'backdrop_widget.dart';
import 'converter_screen.dart';
import 'category.dart';
import 'category_tile.dart';
import 'categoryBloc.dart';
import 'conversionProvider.dart';

class CategoryRoute extends StatefulWidget {

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  CategoryBloc _categoryBloc;

  @override
  void didChangeDependencies() {
    _categoryBloc = CategoryProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Category>(
        stream: _categoryBloc.defaultCategory,
        builder: (context, snapshotDefault) {
          return StreamBuilder<Category>(
              stream: _categoryBloc.currentCategory,
              initialData: snapshotDefault.data,
              builder: (context, snapshotCurrent) {
                if (!snapshotDefault.hasData) {
                  return Center(
                    child: Container(
                      height: 180.0,
                      width: 180.0,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Backdrop(
                    currentCategory: snapshotCurrent.data == null
                        ? snapshotDefault.data
                        : snapshotCurrent.data,
                    frontPanel: snapshotCurrent.data == null
                        ? ConversionProvider(
                            child: ConverterScreen(snapshotDefault.data))
                        : ConversionProvider(
                            child: ConverterScreen(snapshotCurrent.data)),
                    backPanel: _buildCategoryScreen(
                        MediaQuery.of(context).orientation),
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
              });
        });
  }

  void _onCategoryTap(Category category) => _categoryBloc.currentCat.add(category);

  Widget _buildCategoryScreen(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return StreamBuilder<List<Category>>(
          stream: _categoryBloc.categories,
          initialData: List<Category>(),
          builder: (context, snapshot) {
            return ListView(
              itemExtent: 125.0,
              children: snapshot.data.map<Widget>(_buildCategoryTile).toList(),
            );
          });
    } else {
      return StreamBuilder<List<Category>>(
          stream: _categoryBloc.categories,
          initialData: List<Category>(),
          builder: (context, snapshot) {
            return GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 3.0),
              children: snapshot.data.map<Widget>(_buildCategoryTile).toList(),
            );
          });
    }
  }

  Widget _buildCategoryTile(Category category) {
    return CategoryTile(
      category: category,
      onTap: _onCategoryTap,
    );
  }

  @override
  void dispose() {
    _categoryBloc.dispose();
    super.dispose();
  }
}
