import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/models/cart_item.dart';
import 'package:flutter_ebook_shop_app/models/order_item.dart';
import 'package:flutter_ebook_shop_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'auth_provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  String userId;
  String token;

  void update(AuthProvider authProvider, List<OrderItem> orders) {
    userId = authProvider.userId;
    token = authProvider.token;
    _orders = orders;
  }

  List<OrderItem> get orders => [..._orders];

  int get ordersCount => _orders.length;

  Future<bool> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        '${Constants.BASE_URL}${Constants.ORDERS}/$userId.json?auth=$token';

    final now = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': now.toIso8601String(),
            'products': cartProducts
                .map((prod) => {
                      'id': prod.id,
                      'name': prod.name,
                      'quantity': prod.quantity,
                      'price': prod.price,
                    })
                .toList()
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: DateTime.now()));
      notifyListeners();

      return true;
    } catch (error) {
      throw error;
    }
  }

  Future fetchOrders() async {
    final url =
        '${Constants.BASE_URL}${Constants.ORDERS}/$userId.json?auth=$token';

    try {
      final response = await http.get(url);
      final List<OrderItem> orders = [];
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData == null) return;

      responseData.forEach((orderId, orderData) {
        orders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>).map((item) =>
                CartItem(
                    id: item['id'],
                    name: item['name'],
                    quantity: item['quantity'],
                    price: item['price'])).toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });

      _orders = orders.reversed.toList();
      notifyListeners();

      return;
    } catch (error) {

      throw error;
    }
  }
}
