import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/values/dimens.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class CartItemsWidget extends StatelessWidget {

  final String productId;
  final String name;
  final double price;
  final int quantity;


  CartItemsWidget(this.productId, this.name, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(Dimens.MARGIN_08),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.MARGIN_08),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(padding: const EdgeInsets.all(5.0), child: FittedBox(child: Text('\$$price'),),),
          ),
          title: Text(name),
          subtitle: Text('Total: \$${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
