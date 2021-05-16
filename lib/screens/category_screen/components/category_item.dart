import 'package:flutter/material.dart';

import 'package:alemshop/screens/home_screen.dart';

class CategoryItem extends StatelessWidget {
  final int catId;
  final String name;
  final String photo;
  final bool man;
  final bool woman;
  CategoryItem({this.catId, this.name, this.photo, this.man, this.woman});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          category: false,
                          catId: catId,
                          woman: woman,
                          man: man,
                        )));
          },
          child: (photo != null)
              ? Image.network(photo)
              : Center(child: Text('Нет изображения')),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          title: Text(
            name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
