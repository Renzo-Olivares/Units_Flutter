import 'package:flutter/material.dart';
import 'category.dart';
import 'unit.dart';

class ConverterScreen extends StatefulWidget {
  final Category category;

  const ConverterScreen({this.category});

  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  Unit _inputUnits;
  Unit _outputUnits;

  List<DropdownMenuItem> _unitDropdownItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createDropdownItems();
    _setDefaults();
  }

  @override
  void didUpdateWidget(ConverterScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _createDropdownItems();
      _setDefaults();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Input", border: OutlineInputBorder()),
                          style: Theme.of(context).textTheme.display1,
                        ),
                        _buildDropdown(),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Center(
                      child: Icon(
                    Icons.import_export,
                    size: 60.0,
                    color: Colors.black,
                  )),
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Output",
                              border: OutlineInputBorder()),
                          style: Theme.of(context).textTheme.display1),
                      _buildDropdown(),
                    ],
                  ),
                )),
              ],
            );
          } else {
            return Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Input", border: OutlineInputBorder()),
                          style: Theme.of(context).textTheme.display1,
                        ),
                        _buildDropdown(),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Center(
                      child: Icon(
                    Icons.swap_horiz,
                    size: 60.0,
                    color: Colors.black,
                  )),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Output",
                              border: OutlineInputBorder()),
                          style: Theme.of(context).textTheme.display1),
                      _buildDropdown(),
                    ],
                  ),
                )),
              ],
            );
          }
        },
      ),
    );
  }

  //create dropdown items
  void _createDropdownItems() {
    var dropDownItems = <DropdownMenuItem>[];

    for (var unit in widget.category.units) {
      dropDownItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }

    setState(() {
      _unitDropdownItems = dropDownItems;
    });
  }

  void _setDefaults() {
    setState(() {
      _inputUnits = widget.category.units[0];
      _outputUnits = widget.category.units[1];
    });
  }

  ///function that creates dropdown widget
  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4.0)),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                items: _unitDropdownItems,
                onChanged: null,
                isExpanded: true,
                hint: Text("Output Units",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )),
        ),
      ),
    );
  }
}
