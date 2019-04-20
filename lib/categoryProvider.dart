import 'categoryBloc.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends InheritedWidget {
  final CategoryBloc categoryBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CategoryBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CategoryProvider)
              as CategoryProvider)
          .categoryBloc;

  CategoryProvider({Key key, CategoryBloc categoryBloc, Widget child})
      : this.categoryBloc = categoryBloc ?? CategoryBloc(),
        super(child: child, key: key);
}
