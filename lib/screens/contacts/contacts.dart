import 'package:alemshop/models/show_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Contacts extends StatefulWidget {
  Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String name = '';
  String phone = '';
  String message = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DocumentReference docRef;
  final _showalert = ShowAlert();
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController phoneController = TextEditingController();
  // final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Контакты',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Необходимые';
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Ваша имя'),
                  onChanged: (val) {
                    name = val;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Необходимые';
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Номер телефона'),
                  onChanged: (val) {
                    phone = val;
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Необходимые';
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ваше сообшение'),
                  onChanged: (val) {
                    message = val;
                  },
                ),
                SizedBox(height: 12.0),
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: RaisedButton.icon(
                    elevation: 8,
                    color: Colors.greenAccent[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        docRef = FirebaseFirestore.instance
                            .collection('messages')
                            .doc();
                        docRef.set({
                          'documentId': docRef.id,
                          'name': name,
                          'phone': phone,
                          'message': message,
                          'date': DateTime.now().toString(),
                          'answer': '',
                        });
                        Navigator.pop(context);
                        _showalert.showAlertDialog(
                            context, '', 'Ваше сообщение было отправлено!');
                      }
                    },
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white60,
                    ),
                    label: Text('Отправить',
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
