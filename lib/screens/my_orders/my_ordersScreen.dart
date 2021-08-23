// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:alemshop/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Orders> parseData(var response) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    return parsed.map<Orders>((json) => Orders.fromMap(json)).toList();
  }

  Future<List<Orders>> fetchData() async {
    http.Response res = await http
        .get(Uri.parse("http://www.alemshop.com.tm:8000/order-list/"));
    if (res.statusCode == 200) {
      return parseData(res);
    } else
      throw Exception("Unable to fetch data from server");
  }

  Future<void> getColors() async {
    http.Response res = await http
        .get(Uri.parse('http://www.alemshop.com.tm:8000/color-list/'));
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    colorlar = body;
  }

  Future<void> getSize() async {
    http.Response res =
        await http.get(Uri.parse('http://www.alemshop.com.tm:8000/size-list/'));
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    sizelar = body;
  }

  List colorlar = [];
  List sizelar = [];
  String phone = '';

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User _user = auth.currentUser;
    if (_user != null) {
      phone = _user.phoneNumber;
    } else {
      phone = '';
    }
    getSize();
    getColors();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text('Мои заказы'),
      ),
      body: (phone.isNotEmpty)
          ? FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var orders = snapshot.data[index];
                      final userPhone = orders.userPhone;
                      final userName = orders.userName;
                      // final userEmail = orders.userEmail;
                      final alemId = orders.alemId;
                      final name = orders.name;
                      final quantity = orders.quantity;
                      final sizes = orders.size;
                      final myDateTime = orders.date.toString();
                      final colors = orders.colors;
                      final price = orders.price;
                      final inProcess = orders.inProcess;
                      final completed = orders.completed;
                      final id = orders.id;
                      final photo = orders.photo;
                      var colorName = '';
                      var sizeName = '';

                      for (var i = 0; i < sizelar.length; i++) {
                        var url = sizelar[i]['url'];
                        if (url == sizes[0]) {
                          sizeName = sizelar[i]['name'];
                        }
                      }
                      for (var i = 0; i < colorlar.length; i++) {
                        var url = colorlar[i]['url'];
                        if (url == colors[0]) {
                          colorName = colorlar[i]['name'];
                        }
                      }

                      return OrderCard(
                        phone: phone,
                        alemId: alemId,
                        name: name,
                        totalQuantity: quantity,
                        sizeName: sizeName,
                        myDateTime: myDateTime,
                        user: userPhone,
                        colorName: colorName,
                        price: price,
                        inProcess: inProcess,
                        completed: completed,
                        id: id,
                        photo: photo,
                      );
                    });
              })
          : Center(
              child: Text("Пожалуйста войдите"),
            ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final String phone;
  final String alemId;
  final String name;
  final int totalQuantity;
  final String sizeName;
  final String myDateTime;
  final String user;
  final String colorName;
  final double price;
  final bool inProcess;
  final bool completed;

  final int id;
  final String photo;
  OrderCard(
      {Key key,
      this.phone,
      this.alemId,
      this.name,
      this.totalQuantity,
      this.sizeName,
      this.myDateTime,
      this.user,
      this.colorName,
      this.price,
      this.inProcess,
      this.completed,
      this.id,
      this.photo})
      : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isInProcess;
  bool isCompleted;

  @override
  void initState() {
    super.initState();

    isInProcess = widget.inProcess;
    isCompleted = widget.completed;
  }

  @override
  Widget build(BuildContext context) {
   
    return (widget.user == widget.phone)
        ? Container(
            // color: (isInProcess && isCompleted) ? Colors.greenAccent : Colors.white,
            child: Card(
              // color: (isInProcess && isCompleted) ? Colors.greenAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Имя:", style: TextStyle(fontSize: 18)),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("${widget.name}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("AlemId: ${widget.alemId}",
                        style: TextStyle(fontSize: 16)),
                    Text("Количество: ${widget.totalQuantity}",
                        style: TextStyle(fontSize: 16)),
                    widget.colorName != null
                        ? Text("Цвет: ${widget.colorName}",
                            style: TextStyle(fontSize: 16))
                        : Text('Цвет не выбран '),
                    Text("Размер: ${widget.sizeName}",
                        style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Text("Цена: ", style: TextStyle(fontSize: 16)),
                        Text(
                          '${widget.price}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Divider(color: Colors.amber.shade100),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.id != null
                                  ? Text(
                                      'Номер заказа: ${widget.id}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(''),
                              SizedBox(
                                height: 5.0,
                              ),
                              widget.myDateTime != null
                                  ? Text('${widget.myDateTime}')
                                  : Text(''),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('${widget.user}',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: 5,
                              ),
                              (isInProcess && isCompleted)
                                  ? Container(
                                      padding: EdgeInsets.all(5.0),
                                      color: Colors.green,
                                      child: Text('Завершено'),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(5.0),
                                      color: Colors.amber,
                                      child: Text('Готовиться'),
                                    ),
                            ],
                          ),
                          Container(
                              height: MediaQuery.of(context).size.width * 0.25,
                              width: MediaQuery.of(context).size.width * 0.25,
                              color: Colors.black26,
                              child: (widget.photo != null)
                                  ? Image.network(widget.photo)
                                  : Center(child: Text('No photo')))
                        ]),
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
