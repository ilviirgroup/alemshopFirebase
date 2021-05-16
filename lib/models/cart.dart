import 'package:flutter/foundation.dart';

class CartItem {
  final int orderId;
  final String id;
  final String userPhone;
  final String userEmail;
  final String userName;
  final String title;
  final int quantity;
  final double price;
  final String imgUrl;
  final Set colorList;
  final Set sizeList;
  final Set quantityList;

  CartItem({
    @required this.orderId,
    @required this.id,
    @required this.userPhone,
    @required this.userEmail,
    @required this.userName,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imgUrl,
    @required this.colorList,
    @required this.sizeList,
    @required this.quantityList,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    int orderId,
    String productId,
    double price,
    int quantity,
    String title,
    String imgUrl,
    String userPhone,
    String userEmail,
    String userName,
    Set colorList,
    Set sizeList,
    Set quantityList,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(productId, (existingCartItem) {
        for (var color in colorList) {
          existingCartItem.colorList.add(color);
        }
        for (var size in sizeList) {
          existingCartItem.sizeList.add(size);
        }
        for (var quantities in quantityList) {
          if (quantities == existingCartItem.quantityList) {
            existingCartItem.quantityList.add(existingCartItem.quantityList);
          } else {
            existingCartItem.quantityList.add(quantities);
          }
        }
        print(existingCartItem.colorList);
        print(existingCartItem.sizeList);
        print(existingCartItem.quantityList);

        return CartItem(
          orderId: existingCartItem.orderId,
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + quantity,
          imgUrl: existingCartItem.imgUrl,
          userPhone: existingCartItem.userPhone,
          userEmail: existingCartItem.userEmail,
          userName: existingCartItem.userName,
          colorList: existingCartItem.colorList,
          sizeList: existingCartItem.sizeList,
          quantityList: existingCartItem.quantityList,
        );
      });
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            orderId: orderId,
            id: productId,
            title: title,
            price: price,
            quantity: quantity,
            imgUrl: imgUrl,
            userPhone: userPhone,
            userEmail: userEmail,
            userName: userName,
            colorList: colorList,
            sizeList: sizeList,
            quantityList: quantityList),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              orderId: existingCartItem.orderId,
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1,
              imgUrl: existingCartItem.imgUrl,
              userPhone: existingCartItem.userPhone,
              userEmail: existingCartItem.userEmail,
              userName: existingCartItem.userName,
              sizeList: existingCartItem.sizeList,
              colorList: existingCartItem.colorList,
              quantityList: existingCartItem.quantityList));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
