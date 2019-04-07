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

  TextEditingController _controllerIn = TextEditingController();
  TextEditingController _controllerOut = TextEditingController();

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
      body: _buildConverterScreen(MediaQuery.of(context).orientation));
  }

  Widget _buildConverterScreen(Orientation deviceOrientation){
    if (deviceOrientation == Orientation.portrait) {
      return ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controllerIn,
                    onChanged: _onChangeTextIn,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Input", border: OutlineInputBorder()),
                    style: Theme.of(context).textTheme.display1,
                  ),
                  _buildDropdown(true, _onChangeInput),
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
                        controller: _controllerOut,
                        onChanged: _onChangeTextOut,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Output",
                            border: OutlineInputBorder()),
                        style: Theme.of(context).textTheme.display1),
                    _buildDropdown(false, _onChangeOutput),
                  ],
                ),
              )),
        ],
      );
    } else {
      return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _controllerIn,
                  onChanged: _onChangeTextIn,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Input", border: OutlineInputBorder()),
                  style: Theme.of(context).textTheme.display1,
                ),
                _buildDropdown(true, _onChangeInput),
              ],
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextField(
                    controller: _controllerOut,
                    onChanged: _onChangeTextOut,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Output",
                        border: OutlineInputBorder()),
                    style: Theme.of(context).textTheme.display1),
                _buildDropdown(false, _onChangeOutput),
              ],
            ),
          ),
        ],
      );
    }
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
  Widget _buildDropdown(
      bool selectionType, ValueChanged<dynamic> changeFunction) {
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
                value: selectionType ? _inputUnits.name : _outputUnits.name,
                items: _unitDropdownItems,
                onChanged: changeFunction,
                isExpanded: true,
                hint: Text("Select Units",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              )),
        ),
      ),
    );
  }

  void _onChangeOutput(dynamic unitName) {
    double conversion =
        _getNewUnit(unitName).conversion / _outputUnits.conversion;
    double newConvert = double.parse(_controllerOut.text);
    String outputText = (newConvert * conversion).toString();

    setState(() {
      _outputUnits = _getNewUnit(unitName);
      _controllerOut.text = outputText;
    });
  }

  void _onChangeInput(dynamic unitName) {
    setState(() {
      _inputUnits = _getNewUnit(unitName);
      _controllerOut.text = _conversion(_controllerIn.text, true);
    });
  }

  void _onChangeTextIn(dynamic textInput) {
    setState(() {
      _controllerOut.text = _conversion(textInput, true);
    });
  }

  void _onChangeTextOut(dynamic textInput) {
    setState(() {
      _controllerIn.text = _conversion(textInput, false);
    });
  }

  Unit _getNewUnit(dynamic unitName) {
    int newUnitIndex = widget.category.units
        .indexWhere((Unit) => Unit.name.startsWith(unitName));
    return widget.category.units[newUnitIndex];
  }

  String _conversion(dynamic textInput, bool isInput) {
    double input = double.parse(textInput);
    double conversion = isInput
        ? (_outputUnits.conversion / _inputUnits.conversion)
        : (_inputUnits.conversion / _outputUnits.conversion);
    input = input * conversion;

    return input.toString();
  }
}
