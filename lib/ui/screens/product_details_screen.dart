import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/shop_provider.dart';
import 'package:flutter_ebook_shop_app/values/dimens.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class ProductDetailsScreen extends StatelessWidget {
  static const START = '/product-details-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final product = Provider.of<ShopProvider>(context, listen: false)
        .findProductById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name, textAlign: TextAlign.center, maxLines: 1,),
              background: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.dstATop),
                child: Hero(
                    tag: productId,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18),
                softWrap: true,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.MARGIN_16, vertical: Dimens.MARGIN_08),
            )
          ]))
        ],
      ),
    );
  }
}
