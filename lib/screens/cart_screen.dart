import 'dart:convert';

import 'package:alemshop/models/color_provider.dart';
import 'package:alemshop/models/size_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:alemshop/models/cart.dart' show Cart;
import 'package:alemshop/widgets/cart_item.dart';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ваша корзина'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Cумма',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Spacer(),
                    Chip(
                      label: Consumer<Cart>(
                        builder: (_, cart, ch) => Text(
                          '${cart.totalAmount.toStringAsFixed(2)} TMT',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color,
                          ),
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].imgUrl,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  showAlertDialog(BuildContext context, String title, String text) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(text)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String url = "http://alemshop.com.tm:8000/order-list/";
  Dio dio = new Dio(BaseOptions(
    contentType: "application/json",
  ));
  Future<void> sendOrders(
      String ai,
      String name,
      double price,
      List color,
      List size,
      int quantity,
      String phone,
      String email,
      String userName,
      String photo) async {
    try {
      await http
          .post(Uri.parse(url),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, dynamic>{
                "ai": ai,
                "name": name,
                "price": price,
                "color": color,
                "size": size,
                "quantity": quantity,
                "username": userName,
                "userphone": phone,
                "useremail": 'alem@mail.com',
                "completed": false,
                "inprocess": false,
                "photo": photo,
              }))
          .then((http.Response res) {
        print(res.statusCode);
      });
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final colorProvider = Provider.of<FetchColor>(context);
    final sizeProvider = Provider.of<FetchSize>(context);
    // ignore: deprecated_member_use
    return FlatButton(
      padding: EdgeInsets.all(1.0),
      child: _isLoading ? CircularProgressIndicator() : Text('ЗАКАЗАТЬ СЕЙЧАС'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              Widget okButton = FlatButton(
                child: Text("OK"),
                onPressed: () {
                  // if (FirebaseAuth.instance.currentUser != null) {
                  cart.items.forEach((key, value) {
                    print(value.id);
                    print(value.title);
                    print(value.price);
                    print(value.colorList.toList());
                    print(value.sizeList.toList());
                    print(value.quantity);
                    print(value.userName);
                    print(value.userPhone);
                    print(value.userEmail);
                    print(value.imgUrl);
                    http
                        .post(Uri.parse(url),
                            headers: <String, String>{
                              'Content-Type': 'application/json'
                            },
                            body: jsonEncode(<String, dynamic>{
                              "ai": value.id,
                              "name": value.title,
                              "price": value.price,
                              "color": value.colorList.toList(),
                              "size": value.sizeList.toList(),
                              "quantity": value.quantity,
                              "username": value.userName,
                              "userphone": value.userPhone,
                              "useremail": value.userEmail,
                              "completed": false,
                              "inprocess": false,
                              "photo": value.imgUrl
                            }))
                        .then((http.Response res) {
                      print(res.statusCode);
                    });
                    // sendOrders(
                    //     value.id,
                    //     value.title,
                    //     value.price,
                    //     value.colorList.toList(),
                    //     value.sizeList.toList(),
                    //     value.quantity,
                    //     value.userName,
                    //     value.userPhone,
                    //     value.userEmail,
                    //     value.imgUrl);
                  });
                  // } else {
                  //   print('logged');
                  // }

                  widget.cart.clear();
                  Navigator.of(context).pop();
                },
              );
              showAlertDialog(context, "Завершение заказа",
                  "Вы действительно хотите завершить заказ!");
              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Завершение заказа"),
                content: SingleChildScrollView(
                    child: Text("Вы действительно хотите завершить заказ!")),
                actions: [
                  okButton,
                ],
              );
// show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );

              setState(() {
                _isLoading = false;
              });
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
