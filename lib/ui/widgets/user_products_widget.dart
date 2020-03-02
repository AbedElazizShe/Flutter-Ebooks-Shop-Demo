import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/shop_provider.dart';
import 'package:flutter_ebook_shop_app/ui/screens/edit_product_screen.dart';
import 'package:flutter_ebook_shop_app/values/strings.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class UserProductsWidget extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImageUrl;
  final double productPrice;

  UserProductsWidget(this.productId, this.productName, this.productImageUrl,
      this.productPrice);

  @override
  State createState() => _UserProductsWidgetState();
}

class _UserProductsWidgetState extends State<UserProductsWidget> {
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(EditProductScreen.START,
          arguments: {'pageType': 1, 'productId': widget.productId}),
      child: Dismissible(
        key: ValueKey(widget.productId),
        confirmDismiss: (direction) {
          //delete
          if (direction == DismissDirection.startToEnd) {
            return showDialog(
                context: context,
                builder: (ctx) => _alertDialog(ctx)
            );
          } else {
            Navigator.of(context).pushNamed(EditProductScreen.START,
                arguments: {'pageType': 1, 'productId': widget.productId});
          }

          return null;
        },
        onDismissed: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            try {
              await Provider.of<ShopProvider>(context)
                  .deleteProduct(widget.productId);
            } catch (error) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(Strings.DELETE_ERROR)));
            }
          } else
            Navigator.of(context).pushNamed(EditProductScreen.START,
                arguments: {'pageType': 1, 'productId': widget.productId});
        },
        secondaryBackground: Container(
          color: Theme.of(context).primaryColor,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        ),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20.0),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        ),
        child: Card(
          child: ListTile(
            title: Text(widget.productName),
            leading: CircleAvatar(
              key: ValueKey(widget.productImageUrl),
              backgroundImage: NetworkImage(widget.productImageUrl),
            ),
          ),
        ),
      ),
    );
  }

  Widget _alertDialog(BuildContext ctx){
    if(Platform.isAndroid){
      return AlertDialog(
        title: Text(Strings.DELETE_TITLE),
        content: Text(Strings.DELETE_MESSAGE),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(Strings.CANCEL)),
          FlatButton(
              onPressed: () async => _delete(ctx),
              child: Text(Strings.YES)),
        ],
      );
    }else{
      return CupertinoAlertDialog(
        title: Text(Strings.DELETE_TITLE),
        content: Text(Strings.DELETE_MESSAGE),
        actions: <Widget>[
          CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(Strings.CANCEL)),
          CupertinoDialogAction(
            isDefaultAction: true,
              onPressed: () async => _delete(ctx),
              child: Text(Strings.YES)),
        ],
      );
    }
  }

  void _delete(BuildContext ctx) async{
    Navigator.of(ctx).pop(false);
    try {
      await Provider.of<ShopProvider>(context,
          listen: false)
          .deleteProduct(widget.productId);
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Strings.DELETE_ERROR)));
    }
  }
}
