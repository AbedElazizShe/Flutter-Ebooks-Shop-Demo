import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/shop_provider.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/product_widget.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class ProductsWidget extends StatelessWidget {
  final bool isStarred;

  ProductsWidget([this.isStarred = false]);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ShopProvider>(context);
    final products =
        isStarred ? productsData.starredProducts : productsData.products;

    return products.length == 0 ? Center(child: ProgressBar(),) : GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.8,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductWidget(),
      ),
      itemCount: products.length,
    );
  }
}
