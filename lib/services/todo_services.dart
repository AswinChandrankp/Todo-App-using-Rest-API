import 'dart:convert';

import 'package:http/http.dart' as http;



class todoservices{
  static Future <bool>deleteByid(String id) async {
    final url = "http://api.nstack.in/v1/todos/$id";
  final uri = Uri.parse(url);
  final response = await http.delete(uri);
   return response.statusCode == 200;

  }

   static Future<List?>fetchtodos() async{
    final url = "http://api.nstack.in/v1/todos?page=1";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body)as Map;
      final data = json["items"] as List;
      return data;
    } else {
       return null;
      
    }

  }

}