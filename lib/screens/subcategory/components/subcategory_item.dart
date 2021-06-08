import 'dart:convert';
import 'package:alemshop/models/cart.dart';

import 'package:alemshop/screens/product_detail/product_detail_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alemshop/models/show_alert_dialog.dart';
import 'package:alemshop/service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

// final _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance;

class SubCategoryItem extends StatefulWidget {
  final bool isNew;
  final String brand;
  final String gender;
  final String category;
  final int subId;
  final double price;
  final String url;
  final String photo1;
  final String photo2;
  final String photo3;
  final String photo4;
  final String photo5;
  final String photo6;
  final String status;
  final String alemid;
  final String name;
  final String description;
  final List colors;
  final List sizes;
  final String subCategoryId;

  SubCategoryItem(
      {this.isNew,
      this.brand,
      this.gender,
      this.url,
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
      this.category,
      this.alemid,
      this.price,
      this.status,
      this.description,
      this.subCategoryId});

  @override
  _SubCategoryItemState createState() => _SubCategoryItemState();
}

class _SubCategoryItemState extends State<SubCategoryItem> {
  var colorname;
  bool favoritePushed;
  final _showalert = ShowAlert();

  Widget listTile() {
    return ListTile();
  }

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

  String url = 'http://alemshop.com.tm:8000/favorite-list/';
  void postData() {
    var formData = FormData.fromMap({
      // await http
      //     .post(
      //   uri,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json;charset=UTF-8',
      //     'connection': 'keep-alive'
      //   },
      //   body: jsonEncode(
      //     <String, dynamic>{
      'name': widget.name,
      // 'user': '+99363016291',
      // 'date': DateTime.now().toString(),
      'ai': widget.alemid,
      'brand': widget.brand,
      'gender': widget.gender,
      'status': widget.status,
      'color': widget.colors,
      'size': widget.sizes,
      'subcategory': widget.subCategoryId,
      'category': widget.category,
      'description': widget.description,
      'photo': widget.url,
      'photo1': widget.photo1,
      'photo2': widget.photo2,
      'photo3': widget.photo3,
      'photo4': widget.photo4,
      'photo5': widget.photo5,
      'photo6': widget.photo6,
      'price': widget.price,
      'new': widget.isNew,
      //       // 'urls': widget.urls,
    });
    try {
      dio.post(url, data: formData).then((Response res) {
        setState(() {
          print(res.statusCode);
        });
      });
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  Dio dio = new Dio(BaseOptions(
    contentType: "application/json",
  ));
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
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
                    status: widget.status,
                    description: widget.description,
                    subCategory: widget.subCategoryId,
                  ),
                ));
          },
          child: (widget.url != null)
              ? Image.network(widget.url)
              : Center(
                  child: Text('Нет изображения'),
                ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              if (user.currentUser != null) {
                postData();
                _showalert.showAlertDialog(
                    context, "Избранное ", "Добавлено в избранное");
              } else {
                _showalert.showAlertDialog(context, "", "Пожалуйста войдите");
              }
            },
          ),
          backgroundColor: Colors.black45,
          title: Text(
            widget.name,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
