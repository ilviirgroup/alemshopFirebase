import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:alemshop/service.dart';


class FetchColor with ChangeNotifier {
  Uri url = Uri.parse("http://www.alemshop.com.tm:8000/color-list/");
  Future<List<Colorlar>> fetchColors() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return parseColors(response);
    }
  }

  List<Colorlar> parseColors(var response) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
    return parsed.map<Colorlar>((json) => Colorlar.fromMap(json)).toList();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
