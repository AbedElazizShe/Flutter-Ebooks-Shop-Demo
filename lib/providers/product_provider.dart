import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/utils/constants.dart';
import 'package:http/http.dart' as http;

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class ProductProvider with ChangeNotifier {

  // Product details
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  bool isStarred;

  ProductProvider(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isStarred = false});

  //Toggle star value
  void _setStarredValue(bool isStarred){
    this.isStarred = isStarred;
    notifyListeners();
  }

  // Sync star/un-star value with server
  Future<void> changeStarredValue(String userId, String auth) async{
    final starProductUrl = '${Constants.BASE_URL}${Constants.STARRED_PRODUCTS}/$userId/$id.json?auth=$auth';

    final currentStatus = isStarred;
    isStarred = !isStarred;
    notifyListeners();

    try{
      final responseData = await http.put(starProductUrl, body: jsonEncode(isStarred));
      if(responseData.statusCode >= 400){
        _setStarredValue(currentStatus);
      }
    }catch(error){
      _setStarredValue(currentStatus);
    }
  }
}
