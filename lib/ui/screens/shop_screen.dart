import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/products_widget.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class ShopScreen extends StatefulWidget {
  static const START = '/shop-screen';

  final showStarred;

  ShopScreen(this.showStarred);

  @override
  State createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  @override
  Widget build(BuildContext context) {

    return ProductsWidget(widget.showStarred);
  }


}
