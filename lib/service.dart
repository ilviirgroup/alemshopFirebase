import 'dart:convert';

class Category {
  final int id;
  final String ai;
  final String name;
  final String photo;

  Category(this.id, this.ai, this.name, this.photo);

  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(
      json['pk'],
      json['ai'],
      json['name'],
      json['photo'],
    );
  }
}

class SubCategories {
  final int id;
  final String name;
  final String category;

  SubCategories(this.id, this.name, this.category);
  factory SubCategories.fromMap(Map<String, dynamic> json) {
    return SubCategories(json['pk'], json['name'], json['category']);
  }
}

class Products {
  final int id;
  final String name;
  final String status;
  final String description;
  final List colors;
  final List size;
  final String alemid;
  final double price;
  final String brand;
  final bool isNew;
  final String gender;
  final String category;
  final String subCategory;
  final String photo;
  final String photo1;
  final String photo2;
  final String photo3;
  final String photo4;
  final String photo5;
  final String photo6;

  Products(
    this.id,
    this.name,
    this.status,
    this.description,
    this.colors,
    this.size,
    this.alemid,
    this.price,
    this.brand,
    this.isNew,
    this.gender,
    this.category,
    this.subCategory,
    this.photo,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo5,
    this.photo6,
  );
  factory Products.fromMap(Map<String, dynamic> json) {
    return Products(
      json['pk'],
      json['name'],
      json['status'],
      json['description'],
      json['color'],
      json['size'],
      json['ai'],
      json['price'],
      json['brand'],
      json['new'],
      json['gender'],
      json['category'],
      json['subcategory'],
      json['photo'],
      json['photo1'],
      json['photo2'],
      json['photo3'],
      json['photo4'],
      json['photo5'],
      json['photo6'],
    );
  }
}

class Favorites {
  final String userEmail;
  final String userPhone;
  final String photo;
  final String photo1;
  final String photo2;
  final String photo3;
  final String photo4;
  final String photo5;
  final String photo6;
  final String subCategory;
  final String name;
  final List color;
  final List size;
  final String brand;
  final String gender;
  final String alemId;
  final double price;
  final String status;
  final String description;
  final String category;
  final bool isNew;
  final String urlFavorite;
  Favorites(
    this.userEmail,
    this.userPhone,
    this.photo,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo5,
    this.photo6,
    this.subCategory,
    this.name,
    this.color,
    this.size,
    this.brand,
    this.gender,
    this.alemId,
    this.price,
    this.status,
    this.description,
    this.category,
    this.isNew,
    this.urlFavorite,
  );
  factory Favorites.fromMap(Map<String, dynamic> json) {
    return Favorites(
      json['useremail'],
      json['userphone'],
      json['photo'],
      json['photo1'],
      json['photo2'],
      json['photo3'],
      json['photo4'],
      json['photo5'],
      json['photo6'],
      json['subcategory'],
      json['name'],
      json['color'],
      json['size'],
      json['brand'],
      json['gender'],
      json['ai'],
      json['price'],
      json['status'],
      json['description'],
      json['category'],
      json['new'],
      json['url'],
    );
  }
}

class Orders {
  int id;
  String alemId;
  String name;
  double price;
  int quantity;
  List colors;
  List size;
  var date;
  String userPhone;
  String userEmail;
  String userName;
  bool inProcess;
  bool completed;
  String photo;
  Orders(
    this.id,
    this.alemId,
    this.name,
    this.price,
    this.quantity,
    this.colors,
    this.size,
    this.date,
    this.userPhone,
    this.userEmail,
    this.userName,
    this.inProcess,
    this.completed,
    this.photo,
  );
  factory Orders.fromMap(Map<String, dynamic> json) {
    return Orders(
        json['pk'],
        json['ai'],
        json['name'],
        json['price'],
        json['quantity'],
        json['color'],
        json['size'],
        json['date'],
        json['userphone'],
        json['useremail'],
        json['username'],
        json['inprocess'],
        json['completed'],
        json['photo']);
  }
}

class Users {
  final String userName;
  final String userEmail;
  final String userPhone;
  final String password;
  final String surname;

  Users(this.userName, this.userEmail, this.userPhone, this.password,
      this.surname);

  factory Users.fromMap(Map<String, dynamic> json) {
    return Users(
      json['username'],
      json['email'],
      json['phone'],
      json['password'],
      json['surname'],
    );
  }
}

class Size {
  final String sizeUrl;
  final int id;
  final String name;
  final String subCategory;
  Size(this.sizeUrl, this.id, this.name, this.subCategory);

  factory Size.fromMap(Map<String, dynamic> json) {
    return Size(
      json['sizeUrl'],
      json['pk'],
      json['name'],
      json['subcategory'],
    );
  }
}

class Colorlar {
  final String colorUrl;
  final int id;
  final String name;
  Colorlar(this.colorUrl, this.id, this.name);

  factory Colorlar.fromMap(Map<String, dynamic> json) {
    return Colorlar(
      json['url'],
      json['pk'],
      json['name'],
    );
  }
}
