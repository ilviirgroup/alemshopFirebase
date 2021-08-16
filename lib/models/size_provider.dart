import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:alemshop/service.dart';

class FetchSize with ChangeNotifier {
  Uri url = Uri.parse("http://www.alemshop.com.tm:8000/size-list/");

  Future<List<Size>> fetchSize() async {
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      return parsedSize(res);
    }
  }

  List<Size> parsedSize(var response) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    return parsed.map<Size>((json) => Size.fromMap(json)).toList();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
