import 'conversionBloc.dart';
import 'package:flutter/material.dart';

class ConversionProvider extends InheritedWidget {
  final ConversionBloc conversionBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ConversionBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ConversionProvider)
              as ConversionProvider)
          .conversionBloc;

  ConversionProvider({Key key, ConversionBloc conversionBloc, Widget child})
      : this.conversionBloc = conversionBloc ?? ConversionBloc(),
        super(child: child, key: key);
}
