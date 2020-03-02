import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/auth_provider.dart';
import 'package:flutter_ebook_shop_app/providers/cart_provider.dart';
import 'package:flutter_ebook_shop_app/providers/product_provider.dart';
import 'package:flutter_ebook_shop_app/ui/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Consumer<ProductProvider>(
      builder: (ctx, product, child) =>
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              child: GestureDetector(
                child: Hero(
                    tag: product.id,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/placeholder_square.jpg'),
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    )), //Hero
                onTap: () {
                  Navigator.of(context).pushNamed(
                      ProductDetailsScreen.START, arguments: product.id);
                },
              ), // Gesture Detector
              footer: GridTileBar(
                title: Text(
                  product.name,
                  textAlign: TextAlign.start,
                ),
                backgroundColor: Colors.black54,
                trailing: Row(
                  children: <Widget>[
                    //Star a product
                    IconButton(
                      padding: EdgeInsets.zero,
                        icon: product.isStarred
                            ? Icon(Icons.star, color: Theme.of(context).accentColor,)
                            : Icon(Icons.star_border, color: Theme.of(context).accentColor),
                        onPressed: () {
                          product.changeStarredValue(
                              authProvider.userId, authProvider.token);
                        }),
                    //Add to cart
                    IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.shopping_cart, color: Theme.of(context).accentColor),
                        onPressed: () {
                          cartProvider.addItem(
                              product.name, product.id, product.price);
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Added to cart'),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                                label: 'Undo', onPressed: () =>
                                cartProvider.removeSingleItem(product.id)),));
                        })
                  ],
                ),
              ),
            ),
          ), // ClipRRect
    );
  }
}
