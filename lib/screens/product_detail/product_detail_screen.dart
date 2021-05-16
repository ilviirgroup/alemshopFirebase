import 'dart:convert';
import 'dart:async';
import 'package:alemshop/models/cart.dart';

import 'package:alemshop/screens/product_detail/gallery_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';
import 'package:alemshop/models/show_alert_dialog.dart';
import 'package:alemshop/service.dart';

final user = FirebaseAuth.instance;

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  final String name;
  final List colorTypes;
  final List sizeTypes;
  final List urls;
  final int subId;
  final int price;
  final String alemid;
  final String url;
  final String status;
  final String description;

  ProductDetailScreen(
      {this.colorTypes,
      this.sizeTypes,
      this.urls,
      this.subId,
      this.alemid,
      this.price,
      this.url,
      this.status,
      this.description,
      this.name});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _showalert = ShowAlert();
  int orderId;
  int _currentColor = 0;
  int _currentSize = 0;
  int counter = 1;
  int _counter = -1;

  String userPhone = '';
  String userName = '';
  String userEmail = '';

  Set<String> selSize = {};
  Set<String> selColor = {};
  Set<String> quantityList = {};
  List<ProductListTile> colorList;
  List<ProductListTile> sizeList;

  List<NetworkImage> urls;

  List<Users> parseData(String response) {
    final parsed = jsonDecode(response).cast<Map<String, dynamic>>();
    return parsed.map<Users>((json) => Users.fromMap(json));
  }

  Future<List<Users>> fetchData() async {
    http.Response res =
        await http.get(Uri.parse("http://127.0.0.1:8000/user-list/"));
    if (res.statusCode == 200) {
      return parseData(res.body);
    }
  }

  void setColor(String selectedColor) {
    setState(() {
      selColor.add(selectedColor);
    });
  }

  void removeColor(String selectedColor) {
    setState(() {
      selColor.remove(selectedColor);
    });
  }

  void setSize(String selectedSize) {
    setState(() {
      selSize.add(selectedSize);
    });
  }

  void removeSize(String selectedSize) {
    setState(() {
      selSize.remove(selectedSize);
    });
  }

  @override
  void initState() {
    super.initState();

    colorList = widget.colorTypes.map((e) {
      _counter++;
      return ProductListTile(
        name: e,
        checkBox: false,
        setColor: setColor,
        currentColor: _counter,
        removeColor: removeColor,
      );
    }).toList();
    sizeList = widget.sizeTypes.map((e) {
      _counter++;
      return ProductListTile(
        name: e,
        checkBox: false,
        setColor: setSize,
        currentColor: _counter,
        removeColor: removeSize,
      );
    }).toList();
    urls = widget.urls.map((e) => NetworkImage(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Товары'),
            actions: <Widget>[
              FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final users = snapshot.data;
                    for (var item in users) {
                      final name = item.userName;
                      final email = item.userEmail;
                      final phone = item.userPhone;
                      if (phone == user.currentUser.phoneNumber) {
                        userName = name;
                        userEmail = email;
                        userPhone = phone;
                      }
                    }

                    return RaisedButton(
                      color: Colors.amber,
                      onPressed: () {
                        if (user.currentUser != null) {
                          setState(() {
                            quantityList.add(counter.toString());
                          });
                          cart.addItem(
                            orderId,
                            '${widget.alemid}',
                            widget.price.toDouble(),
                            counter,
                            '${widget.name}',
                            '${widget.url}',
                            '$userPhone',
                            '$userEmail',
                            '$userName',
                            selColor,
                            selSize,
                            quantityList,
                          );

                          _showalert.showAlertDialog(
                              context, "В корзину", "Добавлен в корзину");
                        } else {
                          _showalert.showAlertDialog(
                              context, "", "Пожалуйста войдите");
                        }
                        initState();
                      },
                      child: Text("в корзину"),
                    );
                  })
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 400.0,
                    width: 300.0,
                    child: GestureDetector(
                      child: Carousel(
                        boxFit: BoxFit.contain,
                        autoplay: false,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 1000),
                        dotIncreasedColor: Color(0xFFFF335C),
                        dotBgColor: Colors.transparent,
                        dotPosition: DotPosition.bottomCenter,
                        dotVerticalPadding: 10.0,
                        showIndicator: true,
                        indicatorBgPadding: 7.0,
                        images: (urls != null) ? urls : [''],
                        onImageTap: (imageIndex) {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => GalleryPage(
                                    urls: urls,
                                  ),),);
                        },
                      ),
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: Colors.black54,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                      child: Text(
                        widget.name ?? "",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 1.0, color: Colors.black26)),
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${widget.price} TMT",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto'),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (counter != 1) {
                                    counter--;
                                  }
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: MediaQuery.of(context).size.width / 20,
                                child: Icon(Icons.remove, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              '$counter',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  counter++;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: MediaQuery.of(context).size.width / 20,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 15, 0, 15),
                    child: Column(
                      children: [
                        Row(children: [
                          Text(
                            "Артикул: ",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          Text(widget.alemid ?? ""),
                        ]),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "Статус: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(widget.status ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        'Цвет',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      )),
                      Expanded(
                          child: Text(
                        'Размер',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      )),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: colorList,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sizeList,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Описание',
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.description ?? "",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class ProductListTile extends StatefulWidget {
  final String name;
  final int currentColor;
  final bool checkBox;
  final Function setColor;
  final Function removeColor;

  ProductListTile(
      {this.name,
      this.checkBox,
      this.setColor,
      this.currentColor,
      this.removeColor});
  @override
  _ProductListTileState createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  bool isChecked;

  void changeCh() {
    setState(() {
      isChecked = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isChecked = widget.checkBox;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name),
      leading: Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              // widget.setColor(widget.currentColor);
              isChecked = !isChecked;
              if (isChecked) {
                widget.setColor(widget.name);
              } else {
                widget.removeColor(widget.name);
              }
            });
          }),
    );
  }
}
