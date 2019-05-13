import 'dart:async';
import 'category.dart';
import 'unit.dart';
import 'package:rxdart/rxdart.dart';

class ConversionBloc {
  //priv local vars
  String _textIn;
  String _textOut;
  Category _category;
  Unit _inputUnits;
  Unit _outputUnits;

  //input
  final _currentCatController = StreamController<Category>();
  Sink<Category> get currentCat => _currentCatController.sink;

  final _inputUnitController = StreamController<String>();
  Sink<String> get inputName => _inputUnitController.sink;

  final _outputUnitController = StreamController<String>();
  Sink<String> get outputName => _outputUnitController.sink;

  final _textInputController = StreamController<String>();
  Sink<String> get textInput => _textInputController.sink;

  final _textOutputController = StreamController<String>();
  Sink<String> get textOutput => _textOutputController.sink;

  //output
  final _currentCatSubject = BehaviorSubject<Category>();
  Stream<Category> get currentCategory => _currentCatSubject.stream;

  final _outputUnitSubject = BehaviorSubject<Unit>();
  Stream<Unit> get outputUnit => _outputUnitSubject.stream;

  final _inputUnitSubject = BehaviorSubject<Unit>();
  Stream<Unit> get inputUnit => _inputUnitSubject.stream;

  final _outputTextSubject = BehaviorSubject<String>();
  Stream<String> get outputText => _outputTextSubject.stream;

  final _inputTextSubject = BehaviorSubject<String>();
  Stream<String> get inputText => _inputTextSubject.stream;

  final _inputValidationSubject = BehaviorSubject<bool>();
  Stream<bool> get inputValidation => _inputValidationSubject.stream;

  final _outputValidationSubject = BehaviorSubject<bool>();
  Stream<bool> get outputValidation => _outputValidationSubject.stream;

  ConversionBloc() {
    print("conversion bloc");
    //category
    _currentCatController.stream.listen((category) {
      print("setting category ${category.name}");
      _category = category;
      _currentCatSubject.sink.add(_category);

      //units default
      setDefaultUnits(_category);
      if(_inputUnits == null || _outputUnits == null){
        //setDefaultUnits(_category);
      }
    });

    //_onChangeInput
    _inputUnitController.stream.listen((unitName) {
      print("changing input unit $unitName");
      _inputUnits = _getNewUnit(unitName);
      _inputUnitSubject.sink.add(_inputUnits);
      if (_textIn != null) {
        _outputTextSubject.sink.add(_conversion(_textIn, true));
      }
    });

    //_onChangeOutput
    _outputUnitController.stream.listen((unitName) {
      print("changing output unit $unitName");
      _outputUnits = _getNewUnit(unitName);
      _outputUnitSubject.sink.add(_outputUnits);

      if (_textOut != null) {
        double conversion =
            _getNewUnit(unitName).conversion / _outputUnits.conversion;
        double newConvert = double.parse(_textOut);
        _textOut = (newConvert * conversion).toString();

        _outputTextSubject.sink.add(_textOut);
      }
    });

    //_onChangeTextIn
    _textInputController.stream.listen((stringInput) {
      _textIn = stringInput;
      _inputTextSubject.sink.add(_textIn);

      if (stringInput == null || stringInput.isEmpty) {
        _outputTextSubject.sink.add('');
        _inputValidationSubject.sink.add(false);
      } else {
        try {
          _outputTextSubject.sink.add(_conversion(_textIn, true));
          _inputValidationSubject.sink.add(false);
        } on Exception catch (e) {
          print('Error: $e');
          _inputValidationSubject.sink.add(true);
        }
      }
    });

    //_onChangeTextOut
    _textOutputController.stream.listen((stringOutput) {
      _textOut = stringOutput;
      _outputTextSubject.sink.add(_textOut);

      if (stringOutput == null || stringOutput.isEmpty) {
        _inputTextSubject.sink.add('');
        _outputValidationSubject.sink.add(false);
      } else {
        try {
          _inputTextSubject.sink.add(_conversion(_textOut, false));
          _outputValidationSubject.sink.add(false);
        } on Exception catch (e) {
          print('Error: $e');
          _outputValidationSubject.sink.add(true);
        }
      }
    });
  }

  void setDefaultUnits(Category category) {
    print("setting default units for ${category.name}");
    _inputUnits = category.units[0];
    _outputUnits = category.units[1];
    _inputUnitSubject.sink.add(_inputUnits);
    _outputUnitSubject.add(_outputUnits);
  }

  Unit _getNewUnit(String unitName) {
    print("getting new unit $unitName");
    int newUnitIndex =
        _category.units.indexWhere((unit) => unit.name.startsWith(unitName));
    return _category.units[newUnitIndex];
  }

  String _conversion(String textInput, bool isInput) {
    double input = double.parse(textInput);
    double conversion = isInput
        ? (_outputUnits.conversion / _inputUnits.conversion)
        : (_inputUnits.conversion / _outputUnits.conversion);
    input = input * conversion;

    return input.toString();
  }

  void dispose() {
    _currentCatSubject.close();
    _currentCatController.close();

    _textInputController.close();
    _inputTextSubject.close();

    _textOutputController.close();
    _outputTextSubject.close();

    _inputUnitController.close();
    _inputUnitSubject.close();

    _outputUnitController.close();
    _outputUnitSubject.close();

    _inputValidationSubject.close();
    _outputValidationSubject.close();
  }
}
