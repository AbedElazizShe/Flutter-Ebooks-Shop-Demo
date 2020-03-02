import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/cart_provider.dart';
import 'package:flutter_ebook_shop_app/providers/shop_provider.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/badge.dart';
import 'package:flutter_ebook_shop_app/utils/connectivity_utils.dart';
import 'package:provider/provider.dart';
import '../../ui/screens/orders_screen.dart';
import '../../ui/screens/products_screen.dart';
import '../../ui/screens/settings_screen.dart';
import '../../ui/screens/shop_screen.dart';
import '../../values/strings.dart';
import 'cart_screen.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */

// The 2 filtering options
enum FilteringOption { ALL, STARRED }

class HomeScreen extends StatefulWidget {
  static const START = '/home-screen';

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, Object>> _tabs;
  int _selectedPageIndex = 0;
  var _connectionStatus = false;

  @override
  void initState() {

    initConnectivity();

    _tabs = [
      {'tab': ShopScreen(false), 'title': Strings.SHOP},
      {'tab': OrdersScreen(), 'title': Strings.ORDERS},
      {'tab': ProductsScreen(), 'title': Strings.PRODUCTS},
      {'tab': SettingsScreen(), 'title': Strings.SETTINGS},
    ];

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  List<Widget> _selectedPageToolbarIcon(int index) {
    List<Widget> _widgets = [];
    switch (index) {
      case 0:
        _widgets.add(Consumer<CartProvider>(
          builder: (_, cartData, ch) => Badge(
            child: ch,
            value: cartData.itemsCount,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.START);
              }),
        ));
        _widgets.add(PopupMenuButton(
            onSelected: (FilteringOption selectedValue) {
              _tabs.first = {
                'tab': ShopScreen(selectedValue == FilteringOption.STARRED),
                'title': Strings.SHOP
              };
              setState(() {});
            },
            icon: Icon(Icons.sort),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Starred'),
                value: FilteringOption.STARRED,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilteringOption.ALL,
              ),
            ]));
        return _widgets;
      default:
        return _widgets;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_tabs[_selectedPageIndex]['title']),
        actions: _selectedPageToolbarIcon(_selectedPageIndex),
      ),
      body: _tabs[_selectedPageIndex]['tab'],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
                icon:Icon(Icons.home),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(_tabs[0]['title'])),
            BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(_tabs[1]['title'])),
            BottomNavigationBarItem(
                icon: Icon(Icons.apps),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(_tabs[2]['title'])),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(_tabs[3]['title'])),
          ]), // Bottom Navigation Bar Widget
    );
  }


  void _fetchProducts() async {
    if (_connectionStatus)
       await Provider.of<ShopProvider>(context, listen: false)
          .fetchProducts(true);
  }

  void initConnectivity() async {
    ConnectivityUtils connectivity = ConnectivityUtils.getInstance();
    final connectionState = await connectivity.isConnected();

    setState(() {
      _connectionStatus = connectionState;
      _fetchProducts();
    });
  }
}
