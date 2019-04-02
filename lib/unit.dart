class Unit {
  final String name;
  final double conversion;

  const Unit({this.name, this.conversion});

  //create from json
  Unit.fromJson(Map jsonMap)
      : assert(jsonMap['name'] != null),
        assert(jsonMap['conversion'] != null),
        name = jsonMap['name'],
        conversion = jsonMap['conversion'].toDouble();
}
