import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Platform.isAndroid
                ? new CircularProgressIndicator()
                : new CupertinoActivityIndicator());
  }
}