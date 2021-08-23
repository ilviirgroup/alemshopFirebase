import 'dart:convert';

import 'package:alemshop/models/show_alert_dialog.dart';
import 'package:alemshop/screens/home_screen.dart';
import 'package:alemshop/screens/login_and_regis/agreement.dart';
import 'package:alemshop/screens/login_and_regis/cons.dart';
import 'package:alemshop/screens/login_and_regis/verifyPhone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alemshop/service.dart';

class RegPage extends StatefulWidget {
  final Function sahCals;
  RegPage(this.sahCals);
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  bool _isHidden = true;
  bool agreement = false;
  bool isPhoneVerified = false;
  String userName;
  String nameAndSurname;
  String phone;
  // String email;
  String password;
  String url = 'http://www.alemshop.com.tm:8000/user-list/';
  List userNames = [];
  final _showalert = ShowAlert();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void phoneVerification() {
    setState(() {
      isPhoneVerified = !isPhoneVerified;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    http.Response res = await http.get(Uri.parse(url));

    var data =
        jsonDecode(utf8.decode(res.bodyBytes)).cast<Map<String, dynamic>>();
    for (var i = 0; i < data.length; i++) {
      setState(() {
        userNames.add(data[i]['username']);
      });
    }
  }

  Future<void> addUser() async {
    await http
        .post(Uri.parse(url),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode(<String, dynamic>{
              'username': userName, // John Doe
              'surname': nameAndSurname, // Stokes and Sons
              'phone': phone, // 42
              'email': '',
              'password': password,
            }))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.orange[300],
            Colors.orange[400],
            Colors.orange[200],
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // FadeAnimation(
                    //     1,
                    Text(
                      "Добро пожаловать",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          // FadeAnimation(
                          //     1.4,
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.orange[600],
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Необходимые';
                                        }
                                      },
                                      onChanged: (val) {
                                        print(userNames);
                                        if (userNames.contains(val)) {
                                          _showalert.showAlertDialog(
                                              context,
                                              "Псевдоним существует",
                                              "Другой пользователь использует этот псевдоним");
                                        }
                                        setState(() {
                                          userName = val;
                                        });
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Псевдоним",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.person,
                                              color: Colors.orange)),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Необходимые';
                                        }
                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          nameAndSurname = val;
                                        });
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Имя и Фамилия",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.person_add_outlined,
                                            color: Colors.orange,
                                          )),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.all(10),
                                  //   decoration: BoxDecoration(
                                  //       border: Border(
                                  //           bottom: BorderSide(
                                  //               color: Colors.grey[200]))),
                                  //   child: TextFormField(
                                  //     validator: (val) {
                                  //       if (val.isEmpty) {
                                  //         return 'Необходимые';
                                  //       }
                                  //     },
                                  //     onChanged: (val) {
                                  //       setState(() {
                                  //         email = val;
                                  //       });
                                  //     },
                                  //     keyboardType: TextInputType.name,
                                  //     decoration: InputDecoration(
                                  //         hintText: "Электронная почта",
                                  //         hintStyle:
                                  //             TextStyle(color: Colors.grey),
                                  //         border: InputBorder.none,
                                  //         prefixIcon: Icon(
                                  //           Icons.person_add_outlined,
                                  //           color: Colors.orange,
                                  //         )),
                                  //   ),
                                  // ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Необходимые';
                                        }
                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          phone = val;
                                        });
                                      },
                                      maxLength: 12,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: "+993 Телефонный номер",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.orange,
                                        ),
                                        suffix: FlatButton(
                                          color: Colors.green,
                                          child: Text(
                                            "Подтвердить",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            if (phone != null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VerifyPhone(
                                                              phoneVerification:
                                                                  phoneVerification,
                                                              phone: phone)));
                                            } else {
                                              _showalert.showAlertDialog(
                                                  context,
                                                  "Номер телефона",
                                                  "Пожалуйста, напишите свой действующий номер телефона");
                                            }
                                          },
                                        ),
                                      ),
                                      // maxLength: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return 'Необходимые';
                                          }
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Пароль",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.lock,
                                              color: Colors.orange),
                                          suffixIcon: IconButton(
                                            onPressed: _toggleVisibility,
                                            icon: _isHidden
                                                ? Icon(Icons.visibility_off,
                                                    color: Colors.orange)
                                                : Icon(Icons.visibility,
                                                    color: Colors.orange),
                                          ),
                                        ),
                                        obscureText: _isHidden),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // ),
                          SizedBox(height: 20),
                          FlatButton(
                            child:
                                // FadeAnimation(
                                //   1.5,
                                Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Пользовательское \nСоглашение",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _showalert.showAlertDialog(context,
                                                "Соглашение", agreementText);
                                          },
                                          child: Text(
                                            " читать",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16),
                                          )),
                                      Checkbox(
                                        value: agreement,
                                        onChanged: (value) {
                                          setState(() {
                                            agreement = !agreement;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // ),
                            onPressed: () {},
                          ),
                          SizedBox(height: 10),
                          // FadeAnimation(
                          //     1.6,
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.orange[300]),
                            child: Center(
                              child: FlatButton(
                                child: Text(
                                  "регистрироваться",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (isPhoneVerified) {
                                    if (agreement) {
                                      if (_formKey.currentState.validate()) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()));
                                        addUser();
                                        _showalert.showAlertDialog(
                                            context,
                                            "Поздравляем!",
                                            "Вы успешно зарегистрировались");
                                      } else {
                                        _showalert.showAlertDialog(
                                            context,
                                            "Ошибка",
                                            "Все поля должны быть заполнены");
                                      }
                                    } else {
                                      _showalert.showAlertDialog(
                                          context,
                                          "Соглашение",
                                          "пожалуйста, отметьте соглашение");
                                    }
                                  } else {
                                    _showalert.showAlertDialog(
                                        context,
                                        "Ошибка",
                                        "Ваш номер телефона не подтвержден");
                                  }
                                },
                              ),
                            ),
                          ),
                          // ),
                          SizedBox(height: 10),
                          // FadeAnimation(
                          //     1.6,
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.orange[300]),
                            child: Center(
                              child: FlatButton(
                                child: Text(
                                  "назад",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  widget.sahCals();
                                },
                              ),
                            ),
                          )
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
