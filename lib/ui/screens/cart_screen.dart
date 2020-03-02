import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/cart_provider.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/cart/cart_items_widget.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/cart/cart_order_button_widget.dart';
import 'package:flutter_ebook_shop_app/values/dimens.dart';
import 'package:flutter_ebook_shop_app/values/strings.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class CartScreen extends StatelessWidget {
  static const START = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: Text(Strings.CART_SCREEN)),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.only(bottom: Dimens.MARGIN_08),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimens.MARGIN_08, horizontal: Dimens.MARGIN_16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Strings.TOTAL,
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color,
                        )),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  CartOrderButtonWidget()
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItemsWidget(
                cartProvider.items.values.toList()[i].id,
                cartProvider.items.values.toList()[i].name,
                cartProvider.items.values.toList()[i].price,
                cartProvider.items.values.toList()[i].quantity),
            itemCount: cartProvider.itemsCount,
          ))
        ],
      ),
    );
  }
}
