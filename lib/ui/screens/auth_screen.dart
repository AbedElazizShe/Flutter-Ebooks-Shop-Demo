import 'package:flutter/material.dart';
import '../../ui/widgets/auth_card_widget.dart';
import '../../values/dimens.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class AuthScreen extends StatelessWidget {
  static const START = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    // Get the device size
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(top: Dimens.MARGIN_80),
            width: deviceSize.width,
            height: deviceSize.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 150),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: AuthCardWidget())
                ],
              ),
            )));
  }
}
