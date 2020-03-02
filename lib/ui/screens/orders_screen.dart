import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/order_provider.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/orders_widget.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/progress_bar.dart';
import 'package:flutter_ebook_shop_app/values/strings.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class OrdersScreen extends StatefulWidget {

  @override
  State createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  Future _future;

  void _fetchOrders() async {
    _future =
    await Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ProgressBar(),);
          } else {
            if (snapshot.error != null) {
              return Center(child: Text(Strings.ERROR),);
            } else {
              return Consumer<OrderProvider>(builder: (ctx, data, _) => data.ordersCount == 0 ? Center(child: ProgressBar(),) :
                  ListView.builder(itemCount: data.ordersCount,
                      itemBuilder: (ctx, i) =>
                          OrdersWidget(data.orders[i])));
            }
          }
        });
  }
}
