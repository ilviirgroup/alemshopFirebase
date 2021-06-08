import 'dart:convert';

import 'package:alemshop/screens/category_screen/components/category_item.dart';
import 'package:alemshop/models/category_provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CategoryGridView extends StatelessWidget {
  final bool man;
  final bool woman;
  CategoryGridView({this.man, this.woman});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<Categories>(context);
    
    return FutureBuilder(
      future: categoryProvider.getCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final categories = snapshot.data;
        List<CategoryItem> categoryList = [];
        for (var category in categories) {
          final id = category.id;
          final name = category.name;
          final photo = category.photo;

          final categoryitem = CategoryItem(
            catId: id,
            name: name,
            photo: photo,
            man: man,
            woman: woman,
          );
          categoryList.add(categoryitem);
        }
        return GridView(
          children: categoryList,
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
