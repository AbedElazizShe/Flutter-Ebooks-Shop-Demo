import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/models/order_item.dart';
import 'package:flutter_ebook_shop_app/values/dimens.dart';
import 'package:intl/intl.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class OrdersWidget extends StatefulWidget {
  final OrderItem orderItem;

  OrdersWidget(this.orderItem);

  @override
  State createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.orderItem.products.length * 20.0 + 150, 220)
          : 95,
      child: Card(
        margin: EdgeInsets.all(Dimens.MARGIN_08),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.orderItem.amount}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                  icon:
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                  vertical: 4.0, horizontal: Dimens.MARGIN_08),
              height: _isExpanded
                  ? min(widget.orderItem.products.length * 20.0 + 50, 120)
                  : 0,
              child: ListView(
                  children: widget.orderItem.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${prod.quantity}x \$${prod.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList()),
            )
          ],
        ),
      ),
    );
  }
}
