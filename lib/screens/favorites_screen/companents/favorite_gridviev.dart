import 'dart:convert';

import 'package:alemshop/screens/favorites_screen/companents/foverite_item.dart';
import 'package:alemshop/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance;

class FavCategoryGridView extends StatelessWidget {
  List<Favorites> parseData(String response) {
    final parsed = jsonDecode(response).cast<Map<String, dynamic>>();
    return parsed.map<Favorites>((json) => Favorites.fromMap(json)).toList();
  }

  Future<List<Favorites>> fetchData() async {
    http.Response res =
        await http.get(Uri.parse("http://alemshop.com.tm:8000/product-list/"));
    if (res.statusCode == 200) {
      return parseData(res.body);
    } else
      throw Exception("Unable to fetch data from server");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final favorites = snapshot.data;
        List<FavCategoryItem> favoriteList = [];
        for (var item in favorites) {
          final url = item.photo;
          final id = item.subcategory;
          final name = item.name;
          final colors = item.color;
          final sizes = item.size;
          final urls = item.photos;
          final alemid = item.alemId;
          final price = item.price;
          final login = item.data()['login'];
          final status = item.status;
          final description = item.description;

          if (user.currentUser != null) {
            if (login == user.currentUser.phoneNumber) {
              final categoryitem = FavCategoryItem(
                url: url,
                name: name,
                colors: colors,
                sizes: sizes,
                urls: urls,
                subId: id,
                alemid: alemid,
                price: price,
                status: status,
                description: description,
              );
              favoriteList.add(categoryitem);
            }
          }
        }
        return GridView(
          children: favoriteList,
          padding: EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        );
      },
    );
  }
}
