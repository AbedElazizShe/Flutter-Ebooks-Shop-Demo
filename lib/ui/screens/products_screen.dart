import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/shop_provider.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/progress_bar.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/user_products_widget.dart';
import 'package:flutter_ebook_shop_app/utils/connectivity_utils.dart';
import 'package:provider/provider.dart';
import 'edit_product_screen.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */

class ProductsScreen extends StatefulWidget {
  static const START = '/products-screen';

  @override
  State createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final connectivity = ConnectivityUtils.getInstance();
  bool _connectionStatus = true;

  Future<void> _refreshProducts() async {
    if (_connectionStatus) {
      await Provider.of<ShopProvider>(context, listen: false)
          .fetchProducts(true);
    } else {
      await Provider.of<ShopProvider>(context, listen: false)
          .fetchOfflineProducts();
    }
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();
    listenToConnectivityChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            child: Consumer<ShopProvider>(
                builder: (ctx, productsData, _) =>
                    productsData.products.length == 0
                        ? Center(
                            child: ProgressBar(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemBuilder: (ctx, index) => UserProductsWidget(
                                  productsData.products[index].id,
                                  productsData.products[index].name,
                                  productsData.products[index].imageUrl,
                                  productsData.products[index].price),
                              itemCount: productsData.products.length,
                            ),
                          )),
            onRefresh: () => _refreshProducts()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed(
              EditProductScreen.START,
              arguments: {'pageType': 0, 'productId': ''}),
          child: Icon(Icons.add),
        ));
  }

  void initConnectivity() async {
    final connectionState = await connectivity.isConnected();

    setState(() {
      _connectionStatus = connectionState;
    });
  }

  void listenToConnectivityChanges() {
    connectivity.connectionChange.listen((hasConnection) {
      if (mounted) {
        setState(() {
          _connectionStatus = hasConnection;
        });
      }
    });
  }
}
