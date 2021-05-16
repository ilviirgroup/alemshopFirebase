import 'dart:convert';

import 'package:alemshop/screens/subcategory/components/subcategory_item.dart';
import 'package:alemshop/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubCategoryGridView extends StatelessWidget {
  final int subId;
  final int gender;
  SubCategoryGridView({this.subId, this.gender});
  int genderFilter = 1;
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
    print(gender);
    final subCategoryUrl =
        'http://alemshop.com.tm:8000/subcategory-list/$subId';

    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data'),
            // child: CircularProgressIndicator(
            //   backgroundColor: Colors.lightBlueAccent,
            // ),
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
          // final genderFilter = item.gender;
          final subCategoryId = item.subCategory;
          final url = item.photo;
          final photo1 = item.photo1;
          final photo2 = item.photo2;
          final photo3 = item.photo3;
          final photo4 = item.photo4;
          List urls = [];
          if (photo1 != null) {
            urls.add(photo1);
          }
          if (photo2 != null) {
            urls.add(photo2);
          }
          if (photo3 != null) {
            urls.add(photo3);
          }
          if (photo4 != null) {
            urls.add(photo4);
          }

          if (gender == 0) {
            if (subCategoryId == subCategoryUrl) {
              final categoryitem = SubCategoryItem(
                isNew: isNew,
                brand: brand,
                gender: gender.toString(),
                url: url,
                name: name,
                colors: colors,
                sizes: sizes,
                urls: urls,
                subId: subId,
                alemid: alemid,
                price: price,
                status: status,
                description: description,
              );
              productList.add(categoryitem);
            }
          } else {
            if (subCategoryId == subId && gender == genderFilter) {
              final categoryitem = SubCategoryItem(
                isNew: isNew,
                brand: brand,
                gender: gender.toString(),
                url: url,
                name: name,
                colors: colors,
                sizes: sizes,
                urls: urls,
                subId: subId,
                alemid: alemid,
                price: price,
                status: status,
                description: description,
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
