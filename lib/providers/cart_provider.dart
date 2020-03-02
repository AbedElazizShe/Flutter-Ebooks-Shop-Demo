import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/models/cart_item.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addItem(String name, String productId, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (currentItem) => CartItem(
              id: currentItem.id,
              name: currentItem.name,
              quantity: currentItem.quantity + 1,
              price: currentItem.price));
    } else {
      _items.putIfAbsent(productId,
          () => CartItem(id: productId, name: name, quantity: 1, price: price));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (currentItem) => CartItem(
              id: currentItem.id,
              name: currentItem.name,
              quantity: currentItem.quantity - 1,
              price: currentItem.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
