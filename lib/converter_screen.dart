import 'package:flutter/material.dart';
import 'category.dart';
import 'conversionProvider.dart';
import 'conversionBloc.dart';
import 'unit.dart';

class ConverterScreen extends StatefulWidget {
  final Category _category;

  const ConverterScreen(this._category);

  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  ConversionBloc _conversionBloc;
  final _outController = TextEditingController();
  final _inController = TextEditingController();

  @override
  void didUpdateWidget(ConverterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget._category != widget._category){
      //ser default units
      _conversionBloc.setDefaultUnits(widget._category);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_conversionBloc == null){
      _conversionBloc = ConversionProvider.of(context);
      _conversionBloc.setDefaultUnits(widget._category);
    }
  }

  @override
  Widget build(BuildContext context) {
    _conversionBloc.currentCat.add(widget._category);
    return Scaffold(
        body: _buildConverterScreen(MediaQuery.of(context).orientation));
  }

  Widget _buildConverterScreen(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: _conversionBloc.inputText,
                      initialData: '',
                      builder: (context, snapshot) {
                        return StreamBuilder<bool>(
                            stream: _conversionBloc.inputValidation,
                            initialData: false,
                            builder: (context, snapshotValidIn) {
                              _inController.value = _inController.value
                                  .copyWith(text: snapshot.data);
                              return TextField(
                                controller: _inController,
                                onChanged: _onChangeTextIn,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    errorText: snapshotValidIn.data
                                        ? 'Invalid number'
                                        : null,
                                    labelText: "Input",
                                    border: OutlineInputBorder()),
                                style: Theme.of(context).textTheme.display1,
                              );
                            });
                      }),
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
                StreamBuilder<String>(
                    stream: _conversionBloc.outputText,
                    initialData: '',
                    builder: (context, snapshot) {
                      return StreamBuilder<bool>(
                          stream: _conversionBloc.outputValidation,
                          initialData: false,
                          builder: (context, snapshotValidOut) {
                            _outController.value = _outController.value
                                .copyWith(text: snapshot.data);
                            return TextField(
                                controller: _outController,
                                onChanged: _onChangeTextOut,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    errorText: snapshotValidOut.data
                                        ? 'Invalid number'
                                        : null,
                                    labelText: "Output",
                                    border: OutlineInputBorder()),
                                style: Theme.of(context).textTheme.display1);
                          });
                    }),
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
                StreamBuilder<String>(
                    stream: _conversionBloc.inputText,
                    initialData: '',
                    builder: (context, snapshot) {
                      return StreamBuilder<bool>(
                          stream: _conversionBloc.inputValidation,
                          initialData: false,
                          builder: (context, snapshotValidIn) {
                            _inController.value = _inController.value
                                .copyWith(text: snapshot.data);
                            return TextField(
                              controller: _inController,
                              onChanged: _onChangeTextIn,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  errorText: snapshotValidIn.data
                                      ? 'Invalid number'
                                      : null,
                                  labelText: "Input",
                                  border: OutlineInputBorder()),
                              style: Theme.of(context).textTheme.display1,
                            );
                          });
                    }),
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
                StreamBuilder<String>(
                    stream: _conversionBloc.outputText,
                    initialData: '',
                    builder: (context, snapshot) {
                      return StreamBuilder<bool>(
                          stream: _conversionBloc.outputValidation,
                          initialData: false,
                          builder: (context, snapshotValidOut) {
                            _outController.value = _outController.value
                                .copyWith(text: snapshot.data);
                            return TextField(
                                controller: _outController,
                                onChanged: _onChangeTextOut,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    errorText: snapshotValidOut.data
                                        ? 'Invalid number'
                                        : null,
                                    labelText: "Output",
                                    border: OutlineInputBorder()),
                                style: Theme.of(context).textTheme.display1);
                          });
                    }),
                _buildDropdown(false, _onChangeOutput),
              ],
            ),
          ),
        ],
      );
    }
  }

  DropdownMenuItem _buildDropdownItem(dynamic unit) {
    return DropdownMenuItem(
      value: unit.name,
      child: Container(
        child: Text(
          unit.name,
          softWrap: true,
        ),
      ),
    );
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
              child: StreamBuilder<Unit>(
                  stream: _conversionBloc.inputUnit,
                  initialData: widget._category.units[0],
                  builder: (context, snapshotIn) {
                    return StreamBuilder<Unit>(
                        stream: _conversionBloc.outputUnit,
                        initialData: widget._category.units[1],
                        builder: (context, snapshotOut) {
                          return StreamBuilder<Category>(
                              stream: _conversionBloc.currentCategory,
                              initialData: widget._category,
                              builder: (context, snapshotDropdown) {
                                return DropdownButton(
                                  items: snapshotDropdown.data.units
                                      .map(_buildDropdownItem)
                                      .toList(),
                                  value: selectionType
                                      ? snapshotIn.data.name
                                      : snapshotOut.data.name,
                                  onChanged: changeFunction,
                                  isExpanded: true,
                                  hint: Text("Select Units",
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                );
                              });
                        });
                  })),
        ),
      ),
    );
  }

  void _onChangeOutput(dynamic unitName) =>
      _conversionBloc.outputName.add(unitName);
  void _onChangeInput(dynamic unitName) =>
      _conversionBloc.inputName.add(unitName);
  void _onChangeTextIn(String textInput) =>
      _conversionBloc.textInput.add(textInput);
  void _onChangeTextOut(String textInput) =>
      _conversionBloc.textOutput.add(textInput);

  @override
  void dispose() {
    _conversionBloc.dispose();
    super.dispose();
  }
}