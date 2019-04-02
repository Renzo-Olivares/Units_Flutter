// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'category.dart';

/// A custom [Category] widget.
///
/// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class CategoryTile extends StatelessWidget {
  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  // TODO: You'll need the name, color, and iconLocation from main.dart
  final Category category;
  final ValueChanged<Category> onTap;

  //const Category();
  const CategoryTile({this.category, this.onTap});

  /// Builds a custom widget that shows [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    final _fontsize = 24.0;
    final _height = 100.0;
    final _radius = _height / 2;

    // TODO: Build the custom widget here, referring to the Specs.
    return Material(
      color: Colors.transparent,
      child: InkWell(
          splashColor: category.color,
          highlightColor: category.color,
          borderRadius: BorderRadius.all(Radius.circular(_radius)),
          onTap: () => onTap(category), //launch category route
          child: Container(
              height: _height,
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                subtitle: Text(
                  category.name,
                  style: TextStyle(fontSize: _fontsize, color: Colors.black,),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    category.icon,
                    size: 60.0,
                    color: Colors.black,
                  ),
                ),
              ))),
    );
  }
}
