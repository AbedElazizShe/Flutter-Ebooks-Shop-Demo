import 'package:flutter/cupertino.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
@immutable
class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.name,
      @required this.quantity,
      @required this.price});
}
