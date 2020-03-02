import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/auth_provider.dart';
import 'package:flutter_ebook_shop_app/providers/cart_provider.dart';
import 'package:flutter_ebook_shop_app/providers/order_provider.dart';
import 'package:flutter_ebook_shop_app/providers/shop_provider.dart';
import 'package:flutter_ebook_shop_app/ui/screens/auth_screen.dart';
import 'package:flutter_ebook_shop_app/ui/screens/cart_screen.dart';
import 'package:flutter_ebook_shop_app/ui/screens/edit_product_screen.dart';
import 'package:flutter_ebook_shop_app/ui/screens/home_screen.dart';
import 'package:flutter_ebook_shop_app/ui/screens/product_details_screen.dart';
import 'package:flutter_ebook_shop_app/ui/screens/shop_screen.dart';
import 'package:flutter_ebook_shop_app/ui/screens/splash_screen.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class EBooksShopApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Using multiProvider when providing multiple objects
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        //Shop model depends on Auth model, for that reason ChangeNotifierProxyProvider
        //is needed
        ChangeNotifierProxyProvider<AuthProvider, ShopProvider>(
            create: (_) => ShopProvider(),
            update: (_, auth, shopProvider) => shopProvider
              ..update(auth,
                  shopProvider.products == null ? [] : shopProvider.products)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider(),
          update: (_, auth, orderProvider) => orderProvider
            ..update(
                auth, orderProvider.orders == null ? [] : orderProvider.orders),
        )
      ],
      child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
                key: auth.key,
                home: auth.isLoggedIn
                    ? HomeScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, result) =>
                            result.connectionState == ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen()),
                theme: auth.theme,
                initialRoute: '/',
                routes: {
                  HomeScreen.START: (ctx) => HomeScreen(),
                  ShopScreen.START: (ctx) => ShopScreen(false),
                  EditProductScreen.START: (ctx) => EditProductScreen(),
                  ProductDetailsScreen.START: (ctx) => ProductDetailsScreen(),
                  CartScreen.START: (ctx) => CartScreen(),
                },
              )),
    );
  }
}
