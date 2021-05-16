import 'package:alemshop/screens/home_screen.dart';
import 'package:alemshop/screens/login_and_regis/verifyPhone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alemshop/screens/login_and_regis/cons.dart';
import 'package:alemshop/models/show_alert_dialog.dart';

final _firestore = FirebaseFirestore.instance.collection('users');

class LoginPage extends StatefulWidget {
  final Function sahCals;
  LoginPage(this.sahCals);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _showAlert = ShowAlert();
  bool _isHidden = true;
  // bool savePass = false;
  String username;
  String password;
  String existingPassword;
  String phoneNumber;
  bool isPhoneVerified = false;
  String phone = '';

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void phoneVerification() {
    setState(() {
      isPhoneVerified = !isPhoneVerified;
    });
  }

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
    return SafeArea(
      child: Scaffold(
        body: (phone.isNotEmpty)
            ? Center(child: Text('Вы вошли в систему'))
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.orange[300],
                  Colors.orange[400],
                  Colors.orange[200],
                ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // FadeAnimation(
                          //     1,
                          Text(
                            "Авторизоваться",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          )
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
                                  height: 50,
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
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              username = value;
                                            });
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: "Псевдоним",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.account_circle,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {
                                                password = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Пароль",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.lock,
                                                color: Colors.orange,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: _toggleVisibility,
                                                icon: _isHidden
                                                    ? Icon(
                                                        Icons.visibility_off,
                                                        color: Colors.orange,
                                                      )
                                                    : Icon(
                                                        Icons.visibility,
                                                        color: Colors.orange,
                                                      ),
                                              ),
                                            ),
                                            obscureText: _isHidden),
                                      ),
                                    ],
                                  ),
                                ),
                                // ),
                                SizedBox(
                                  height: 20,
                                ),
                                // FadeAnimation(
                                //     1.6,
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.orange[300]),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: _firestore.snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor:
                                                  Colors.lightBlueAccent,
                                            ),
                                          );
                                        }
                                        final users = snapshot.data.docs;
                                        for (var user in users) {
                                          final existingUsername =
                                              user.data()['username'];
                                          final existingPass =
                                              user.data()['password'];
                                          final existingPhoneNumber =
                                              user.data()['phone'];
                                          if (username == existingUsername) {
                                            username = existingUsername;
                                            existingPassword = existingPass;
                                            phoneNumber = existingPhoneNumber;
                                          }
                                        }
                                        return Center(
                                          child: FlatButton(
                                            child: Text(
                                              "Авторизоваться",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              if (password ==
                                                  existingPassword) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VerifyPhone(
                                                              phone:
                                                                  phoneNumber,
                                                              phoneVerification:
                                                                  phoneVerification,
                                                            )));

                                                // FirebaseAuth.instance
                                                //     .signInWithPhoneNumber(
                                                //         phoneNumber: phoneNumber,
                                                //         )
                                                //     .then((value) => Navigator.push(
                                                //         context,
                                                //         MaterialPageRoute(
                                                //             builder: (context) =>
                                                //                 HomeScreen())));

                                              } else {
                                                _showAlert.showAlertDialog(
                                                    context,
                                                    'Ошибка',
                                                    'Неверный ник или пароль');
                                              }
                                              if (isPhoneVerified) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()));
                                              }
                                            },
                                          ),
                                        );
                                      }),
                                ),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
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
                                        "Зарегистрироваться",
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
