import 'dart:convert';
import 'package:alemshop/models/cart.dart';

import 'package:alemshop/screens/product_detail/product_detail_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:alemshop/models/show_alert_dialog.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// final _firestore = FirebaseFirestore.instance;
// final user = FirebaseAuth.instance;

class SubCategoryItem extends StatefulWidget {
  final bool isNew;
  final String brand;
  final String gender;
  final int subId;
  final int price;
  final String url;
  final String status;
  final String alemid;
  final String name;
  final String description;
  final List colors;
  final List sizes;
  final List urls;
  SubCategoryItem(
      {this.isNew,
      this.brand,
      this.gender,
      this.url,
      this.name,
      this.colors,
      this.sizes,
      this.urls,
      this.subId,
      this.alemid,
      this.price,
      this.status,
      this.description});

  @override
  _SubCategoryItemState createState() => _SubCategoryItemState();
}

class _SubCategoryItemState extends State<SubCategoryItem> {
  bool favoritePushed;
  final _showalert = ShowAlert();

  Widget listTile() {
    return ListTile();
  }

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
                    colorTypes: widget.colors,
                    sizeTypes: widget.sizes,
                    urls: widget.urls,
                    subId: widget.subId,
                    alemid: widget.alemid,
                    price: widget.price,
                    url: widget.url,
                    status: widget.status,
                    description: widget.description,
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
              // if (user.currentUser != null) {
              Uri uri = Uri.parse('http://alemshop.com.tm:8000/favorite-list/');
              http
                  .post(uri,
                      headers: <String, String>{
                        'Connection-Type': 'application/json; charset=UTF-8',
                        'connection': 'keep-alive'
                      },
                      body: jsonEncode(<String, dynamic>{
                        'name': widget.name,
                        'user': user.currentUser.phoneNumber,
                        'date': DateTime.now().toString(),
                        'ai': widget.alemid,
                        'brand': widget.brand,
                        'gender': widget.gender,
                        'status': widget.status,
                        'color': widget.colors,
                        'size': widget.sizes,
                        'subcategory': widget.subId,
                        'category': 2,
                        // 'description': widget.description,
                        'url': widget.url,
                        // 'price': widget.price,
                        // 'urls': widget.urls,
                      }))
                  .then((http.Response res) {
                setState(() {
                  print(res);
                });
              });

              _showalert.showAlertDialog(
                  context, "Избранное ", "Добавлено в избранное");
              // } else {
              //   _showalert.showAlertDialog(context, "", "Пожалуйста войдите");
              // }
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
