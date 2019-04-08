import 'dart:convert';
import 'dart:async';
import 'dart:io';

class currencyApi{
  final _httpClient = HttpClient();
  final _url= 'flutter.udacity.com';

  Future<double> convert(String category, String amount, String fromUnit, String toUnit) async{
    final uri = Uri.https(_url, '/$category/convert',
    {'amount': amount, 'from': fromUnit, 'to':toUnit});

    final jsonResponse = await _getJson(uri);
    if(jsonResponse == null || jsonResponse['status'] == null){
      print('Error retrieving conversion.');
      return null;
    }else if(jsonResponse['status'] == 'error'){
      print(jsonResponse['message']);
      return null;
    }

    return jsonResponse['conversion'].toDouble();
  }

  Future<List> getUnits(String category) async{
    final uri = Uri.https(_url, '/$category');

    final jsonResponse = await _getJson(uri);
    if(jsonResponse == null || jsonResponse['units'] == null){
      print('Error retrieving units');
      return null;
    }

    return jsonResponse['units'];
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async{
    try{
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if(httpResponse.statusCode != HttpStatus.ok){
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      final jsonResponse = json.decode(responseBody);

      return jsonResponse;
    }on Exception catch(e){
      print('$e');
      return null;;
    }
  }
}