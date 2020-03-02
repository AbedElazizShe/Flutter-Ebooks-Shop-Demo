import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/cart_provider.dart';
import 'package:flutter_ebook_shop_app/providers/order_provider.dart';
import 'package:flutter_ebook_shop_app/values/strings.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class CartOrderButtonWidget extends StatefulWidget {
  @override
  State createState() => _CartOrderButtonWidgetState();
}

class _CartOrderButtonWidgetState extends State<CartOrderButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    bool _isLoading = false;

    return FlatButton(
      onPressed: cartProvider.totalAmount <= 0 || _isLoading ? null :
      () async{
        setState(() {
          _isLoading = true;
        });
        await Provider.of<OrderProvider>(context, listen: false).addOrder(cartProvider.items.values.toList(), cartProvider.totalAmount);
        setState(() {
          _isLoading = false;
        });

        cartProvider.clearCart();
      },
      child: _isLoading ? CircularProgressIndicator() : Text(Strings.ORDER),

    );
  }
}
