import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.238.222:5000';

fetchData(String url) async {
  final response = await http.get(Uri.parse(url));
  return response.body;
}

Future<List> getFeaturedProducts(List<String> list) async {
  List<dynamic> result = [];
  final response = await http.post(
    Uri.parse('$baseUrl/featureProducts'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'search_history': list,
    }),
  );

  if (response.statusCode == 200) {
    // Parse the JSON response
    var jsonResponse = jsonDecode(response.body);
    result = jsonResponse['ids'];
  } else {}
  return result;
}

Future<List> getRecommendations(List<String> list) async {
  List<dynamic> result = [];
  final response = await http.post(
    Uri.parse('$baseUrl/recommend'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'product_name_keywords': list,
    }),
  );

  if (response.statusCode == 200) {
    // Parse the JSON response
    var jsonResponse = jsonDecode(response.body);
    result = jsonResponse['ids'];
  } else {}
  return result;
}
