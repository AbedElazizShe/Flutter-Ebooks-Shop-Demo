import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/auth_provider.dart';
import 'package:flutter_ebook_shop_app/style/styles.dart';
import 'package:flutter_ebook_shop_app/values/dimens.dart';
import 'package:flutter_ebook_shop_app/values/strings.dart';
import 'package:provider/provider.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class SettingsScreen extends StatefulWidget {
  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(Dimens.MARGIN_08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(Strings.THEME),
            trailing: themeSwitcher(),
          ),
          ListTile(
            title: Text(Strings.LOGOUT),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
    ));
  }

  Widget themeSwitcher(){
    if(Platform.isAndroid){
      return Switch(
        value: Provider.of<AuthProvider>(context).theme == lightTheme,
        onChanged: (bool v) => changeTheme(v),
      );
    }else{
      return CupertinoSwitch(
        value: Provider.of<AuthProvider>(context).theme == lightTheme,
        onChanged: (bool v) => changeTheme(v),
      );
    }
  }

  void changeTheme(bool isLightTheme){
    if (isLightTheme) {
      Provider.of<AuthProvider>(context, listen: false)
          .setTheme(lightTheme, true);
    } else {
      Provider.of<AuthProvider>(context, listen: false)
          .setTheme(darkTheme, false);
    }
  }
}
