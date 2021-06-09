import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alemshop/screens/product_detail/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavCategoryItem extends StatefulWidget {
  final String subCategory;
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
  final String category;
  final String status;
  final String description;
  final String urlFav;

  FavCategoryItem({
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
    this.subCategory,
    this.alemid,
    this.price,
    this.status,
    this.description,
    this.category,
    this.urlFav,
  });

  @override
  _FavCategoryItemState createState() => _FavCategoryItemState();
}

class _FavCategoryItemState extends State<FavCategoryItem> {
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
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
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
      Map<String, dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      var url = body['url'];
      var name = body['name'];
      var map = {'name': name, 'url': url};
      sizelar.add(body['name']);
      sizeMap.add(map);
    }
  }

  void deleteFavItem() async {
    var uri = Uri.encodeFull(widget.urlFav);
    await http.delete(Uri.parse(uri)).then((http.Response res) {
      setState(() {
        print(res.statusCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.urlFav);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                          colorTypes: colorlar,
                          sizeTypes: sizelar,
                          sizeMap: sizeMap,
                          colorMap: colorMap,
                          subCategory: widget.subCategory,
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
                          name: widget.name,
                        )));
          },
          child: Image.network(widget.url ?? 'No photo'),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteFavItem();
            },
          ),
          backgroundColor: Colors.black45,
          title: Text(
            '${widget.name}',
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
