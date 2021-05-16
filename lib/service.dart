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
        json['subCategory'],
        json['photo'],
        json['photo1'],
        json['photo2'],
        json['photo3'],
        json['photo4']);
  }
}

class Favorites {
  final String photo;
  final String subCategory;
  final String name;
  final List color;
  final List size;
  final List photos;
  final String alemId;
  final double price;
  final String status;
  final String description;
  Favorites(
    this.photo,
    this.subCategory,
    this.name,
    this.color,
    this.size,
    this.photos,
    this.alemId,
    this.price,
    this.status,
    this.description,
  );
  factory Favorites.fromMap(Map<String, dynamic> json) {
    return Favorites(
        json['photo'],
        json['subCategory'],
        json['name'],
        json['color'],
        json['size'],
        json['photos'],
        json['alemId'],
        json['price'],
        json['status'],
        json['description']);
  }
}

class Orders {
  int id;
}

class Users {
  final String userName;
  final String userEmail;
  final String userPhone;

  Users(this.userName, this.userEmail, this.userPhone);

  factory Users.fromMap(Map<String, dynamic> json) {
    return Users(
      json['username'],
      json['email'],
      json['phone'],
    );
  }
}
