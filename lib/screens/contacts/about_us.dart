import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('О нас'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Наш номер',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              Text(
                '+993 65 53-10-16',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
