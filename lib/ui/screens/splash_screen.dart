import 'package:flutter/material.dart';
/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Center(child: FlutterLogo(size: 120),));
  }
}