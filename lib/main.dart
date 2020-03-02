import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/ui/app.dart';
import 'package:flutter_ebook_shop_app/utils/connectivity_utils.dart';

/* main is the first function to be called when the app starts
  runApp() takes a given widget and makes it the root of all the widget in the
  app. So in this example, runApp takes to EBooksShopApp class that contains the
  root widget.
 */
void main() {
  runApp(EBooksShopApp());

  ConnectivityUtils.getInstance().initialize();

}

