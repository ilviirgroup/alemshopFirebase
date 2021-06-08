import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alemshop/models/cart.dart';

import 'package:alemshop/screens/product_detail/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final user = FirebaseAuth.instance;

class SearchListItem extends StatefulWidget {
  final int subId;
  final double price;
  final String url;
  final String photo1;
  final String photo2;
  final String photo3;
  final String photo4;
  final String photo5;
  final String photo6;
  final String alemid;
  final String name;
  final List colors;
  final List sizes;
  final String status;
  final String description;
  final String subCategoryId;
  SearchListItem(
      {this.url,
      this.photo1,
      this.photo2,
      this.photo3,
      this.photo4,
      this.photo5,
      this.photo6,
      this.name,
      this.colors,
      this.sizes,
      this.subId,
      this.alemid,
      this.price,
      this.status,
      this.description,
      this.subCategoryId});

  @override
  _SearchListItemState createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem> {
  List colorlar = [];
  List sizelar = [];
  List colorMap = [];
  List sizeMap = [];

  @override
  void initState() {
    super.initState();
    getColors();
    getSize();
  }

  Future<void> getColors() async {
    for (var item in widget.colors) {
      http.Response res = await http.get(Uri.parse(item));
      Map<String, dynamic> body = jsonDecode(res.body);
      var url = body['url'];
      var name = body['name'];
      var map = {'name': name, 'url': url};
      colorlar.add(body['name']);
      colorMap.add(map);
    }
  }

  Future<void> getSize() async {
    for (var item in widget.sizes) {
      http.Response res = await http.get(Uri.parse(item));
      Map<String, dynamic> body = jsonDecode(res.body);
      var url = body['url'];
      var name = body['name'];
      var map = {'name': name, 'url': url};
      sizelar.add(body['name']);
      sizeMap.add(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return ListTile(
      contentPadding: EdgeInsets.all(10),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      name: widget.name,
                      sizeMap: sizeMap,
                      colorMap: colorMap,
                      colorTypes: colorlar,
                      sizeTypes: sizelar,
                      subId: widget.subId,
                      alemid: widget.alemid,
                      price: widget.price,
                      url: widget.url,
                      photo1: widget.photo1,
                      photo2: widget.photo2,
                      photo3: widget.photo3,
                      photo4: widget.photo4,
                      photo5: widget.photo5,
                      photo6: widget.photo6,
                      description: widget.description,
                      status: widget.status,
                      subCategory: widget.subCategoryId,
                    )));
      },
      title: Text(widget.name),
      leading: (widget.url != null)
          ? Image.network(widget.url)
          : Center(
              child: Text('Нет изображения'),
            ),
      trailing: Text(widget.price.toString() + " TMT"),
    );
  }
}
