<<<<<<< HEAD
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// final _firestore = FirebaseFirestore.instance
//     .collection('orders')
//     .orderBy('id', descending: true)
//     .snapshots();
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance
    .collection('orders')
    .orderBy('id', descending: true)
    .snapshots();
>>>>>>> 932453198e22465e88897da6f287eeec6d17c279

class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
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
  }

  @override
  Widget build(BuildContext context) {
    print(phone);
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text('Мои заказы'),
      ),
      body: (phone.isNotEmpty)
          ? StreamBuilder(
              // stream:,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var orders = snapshot.data.docs[index];

                      final user = orders.data()['user'];

                      final alemId = orders.data()['alemid'];
                      final name = orders.data()['name'];
                      final totalQuantity = orders.data()['quantity'];
                      final quantities = orders.data()['quantities'];
                      final sizes = orders.data()['size'];
                      final myDateTime = orders.data()['date'];
                      final colors = orders.data()['color'];
                      final price = orders.data()['price'];
                      final inProcess = orders.data()['inProcess'];
                      final completed = orders.data()['completed'];
                      final documentId = orders.data()['documentId'];
                      final id = orders.data()['id'];
                      final photo = orders.data()['imgUrl'];
                      return OrderCard(
                        phone: phone,
                        alemId: alemId,
                        name: name,
                        quantities: quantities,
                        totalQuantity: totalQuantity,
                        sizes: sizes,
                        myDateTime: myDateTime,
                        user: user,
                        colors: colors,
                        price: price,
                        inProcess: inProcess,
                        completed: completed,
                        id: id,
                        documentId: documentId,
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
  final List quantities;
  final int totalQuantity;
  final List sizes;
  final String myDateTime;
  final String user;
  final List colors;
  final double price;
  final bool inProcess;
  final bool completed;
  final String documentId;
  final int id;
  final String photo;
  OrderCard(
      {Key key,
      this.phone,
      this.alemId,
      this.name,
      this.quantities,
      this.totalQuantity,
      this.sizes,
      this.myDateTime,
      this.user,
      this.colors,
      this.price,
      this.inProcess,
      this.completed,
      this.documentId,
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
                    Text("Количество: ${widget.quantities}",
                        style: TextStyle(fontSize: 16)),
                    Text("Общее количество: ${widget.totalQuantity}",
                        style: TextStyle(fontSize: 16)),
                    widget.colors != null
                        ? Text("Цвет: ${widget.colors}",
                            style: TextStyle(fontSize: 16))
                        : Text('Цвет не выбран '),
                    Text("Размер: ${widget.sizes}",
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
