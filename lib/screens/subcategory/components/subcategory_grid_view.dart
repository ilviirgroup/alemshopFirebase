import 'dart:convert';

import 'package:alemshop/screens/subcategory/components/subcategory_item.dart';
import 'package:alemshop/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubCategoryGridView extends StatelessWidget {
  final int subId;
  final String gender;
  SubCategoryGridView({this.subId, this.gender});

  List<Products> parseData(var res) {
    final parsed = jsonDecode(utf8.decode(res.bodyBytes)).cast<Map<String, dynamic>>();
    return parsed.map<Products>((json) => Products.fromMap(json)).toList();
  }

  Future<List<Products>> fetchData() async {
    http.Response res =
        await http.get(Uri.parse("http://alemshop.com.tm:8000/product-list/"));
    if (res.statusCode == 200) {
      return parseData(res);
    } else
      throw Exception("Unable to fetch data from server");
  }

  @override
  Widget build(BuildContext context) {
    final subCategoryUrl =
        'http://alemshop.com.tm:8000/subcategory-list/$subId';

    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            // child: Text('No data'),
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final products = snapshot.data;

        List<SubCategoryItem> productList = [];

        for (var item in products) {
          final id = item.id;
          final name = item.name;
          final status = item.status;
          final description = item.description;
          final colors = item.colors;
          final sizes = item.size;
          final alemid = item.alemid;
          final price = item.price;
          final brand = item.brand;
          final isNew = item.isNew;
          final genderFilter = item.gender;
          final subCategoryId = item.subCategory;
          final category = item.category;
          final url = item.photo;
          final photo1 = item.photo1;
          final photo2 = item.photo2;
          final photo3 = item.photo3;
          final photo4 = item.photo4;
          final photo5 = item.photo5;
          final photo6 = item.photo6;

          if (gender == 'none') {
            if (subCategoryId == subCategoryUrl) {
              final categoryitem = SubCategoryItem(
                isNew: isNew,
                brand: brand,
                gender: genderFilter,
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
                category: category,
                subId: subId,
                alemid: alemid,
                price: price,
                status: status,
                description: description,
                subCategoryId: subCategoryId,
              );
              productList.add(categoryitem);
            }
          } else {
            if (subCategoryId == subCategoryUrl && gender == genderFilter) {
              final categoryitem = SubCategoryItem(
                isNew: isNew,
                brand: brand,
                gender: gender.toString(),
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
                category: category,
                subId: subId,
                alemid: alemid,
                price: price,
                status: status,
                description: description,
                subCategoryId: subCategoryId,
              );

              productList.add(categoryitem);
            }
          }
        }
        return GridView(
          children: productList,
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
