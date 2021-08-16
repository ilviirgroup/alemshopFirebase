import 'dart:convert';

import 'package:alemshop/screens/favorites_screen/companents/foverite_item.dart';
import 'package:alemshop/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance;

class FavCategoryGridView extends StatefulWidget {
  @override
  _FavCategoryGridViewState createState() => _FavCategoryGridViewState();
}

class _FavCategoryGridViewState extends State<FavCategoryGridView> {
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    // if (user.currentUser.phoneNumber != null) {}
  }

  List parseData(var response) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
    return parsed.map((json) => Favorites.fromMap(json)).toList();
  }

  Future<List> fetchData() async {
    http.Response res =
        await http.get(Uri.parse("http://www.alemshop.com.tm:8000/favorite-list/"));
    if (res.statusCode == 200) {
      return parseData(res);
    } else
      throw Exception("Unable to fetch data from server");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
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
              final userEmail = item.userEmail;
              final userPhone = item.userPhone;
              final photo1 = item.photo1;
              final photo2 = item.photo2;
              final photo3 = item.photo3;
              final photo4 = item.photo4;
              final photo5 = item.photo5;
              final photo6 = item.photo6;
              final subCategory = item.subCategory;
              final name = item.name;
              final colors = item.color;
              final sizes = item.size;
              final alemid = item.alemId;
              final price = item.price;
              // final login = item.data()['login'];
              final status = item.status;
              final description = item.description;
              final category = item.category;
              final urlFav = item.urlFavorite;

              // if (userPhone == user.currentUser.phoneNumber) {
              final categoryitem = FavCategoryItem(
                url: url,
                photo1: photo1,
                photo2: photo2,
                photo3: photo3,
                photo4: photo4,
                photo5: photo5,
                photo6: photo6,
                name: name,
                colors: colors,
                sizes: sizes,
                subCategory: subCategory,
                alemid: alemid,
                price: price,
                status: status,
                description: description,
                category: category,
                urlFav: urlFav,
              );
              if (user.currentUser != null) {
                favoriteList.add(categoryitem);
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
          }),
    );
  }
}
