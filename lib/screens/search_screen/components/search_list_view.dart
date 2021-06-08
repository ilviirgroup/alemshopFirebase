import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:alemshop/screens/category_screen/components/category_item.dart';
import 'package:alemshop/screens/search_screen/components/search_list_item.dart';
import 'package:alemshop/screens/subcategory/components/subcategory_item.dart';
import 'package:alemshop/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// final _firestore = FirebaseFirestore.instance;

class SearchListView extends StatelessWidget {
  final String name;
  SearchListView({this.name});

  List<Products> parseData(String response) {
    final parsed = jsonDecode(response).cast<Map<String, dynamic>>();
    return parsed.map<Products>((json) => Products.fromMap(json)).toList();
  }

  Future<List<Products>> fetchData() async {
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

        final categories = snapshot.data;
        List<SearchListItem> categoryList = [];
        for (var category in categories) {
          final id = category.id;
          final String name = category.name;
          final colors = category.colors;
          final sizes = category.size;
          final url = category.photo;
          final photo1 = category.photo1;
          final photo2 = category.photo2;
          final photo3 = category.photo3;
          final photo4 = category.photo4;
          final photo5 = category.photo5;
          final photo6 = category.photo6;
          final String alemid = category.alemid;
          final price = category.price;
          final subCategoryId = category.subCategory;
          final description = category.description;
          final status = category.status;
          final regex = RegExp('${this.name}');
          final categoryitem = SearchListItem(
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
            subId: id,
            alemid: alemid,
            price: price,
            description: description,
            status: status,
            subCategoryId: subCategoryId,
          );
          if ((regex.hasMatch(alemid.toLowerCase()) ||
                  regex.hasMatch(name) ||
                  regex.hasMatch(name.toLowerCase())) &&
              this.name != '') {
            categoryList.add(categoryitem);
          }
        }
        return ListView(
          children: categoryList,
          padding: EdgeInsets.all(10.0),
        );
      },
    );
  }
}
