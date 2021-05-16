import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class Filters with ChangeNotifier {
  bool man = true;
  bool woman = true;
  Filters({this.man, this.woman});

  bool get manFilter {
    return man;
  }

  bool get womanFilter {
    return woman;
  }

  void changeMan() {
    man = !man;
    notifyListeners();
  }

  void changeWoman() {
    woman = !woman;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://flutter-update.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

    notifyListeners();
  }
}
