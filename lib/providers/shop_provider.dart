import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/helpers/db_helper.dart';
import 'package:flutter_ebook_shop_app/providers/auth_provider.dart';
import 'product_provider.dart';
import 'package:flutter_ebook_shop_app/utils/constants.dart';
import 'package:http/http.dart' as http;

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class ShopProvider with ChangeNotifier {
  // We get the list of products by using the user id and user token
  String userId;
  String token;
  String imageUrl;

  var _isLoading;

  final _db = DBHelper();

  // The list of products
  List<ProductProvider> _products = [];

  AuthProvider _authProvider;

  bool get isLoading => _isLoading;

  void update(AuthProvider authProvider, List<ProductProvider> products) {
    userId = authProvider.userId;
    token = authProvider.token;
    _products = products;
    _authProvider = authProvider;
  }

  // return products
  List<ProductProvider> get products =>
      [..._products]; // return a copy of _products

  String get uploadedImageUrl => imageUrl;

  // return starred products
  List<ProductProvider> get starredProducts =>
      _products.where((product) => product.isStarred).toList();

  ProductProvider findProductById(String productId) =>
      _products.firstWhere((product) => product.id == productId);


  // add a new product
  Future<bool> addNewProduct(ProductProvider product) async {
    final addProductUrl =
        '${Constants.BASE_URL}${Constants.PRODUCTS}.json?auth=$token';

    try {
      final responseData = await http.post(addProductUrl,
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId
          }));

      //{name: -M-AqWHMcRA9hvRFv2z-}
      //print(json.decode(responseData.body));

      final productId = json.decode(responseData.body)['name'];

      _products.insert(
          0,
          ProductProvider(
              id: productId,
              name: product.name,
              description: product.description,
              imageUrl: product.imageUrl,
              price: product.price));
      notifyListeners();

      _db.insert(Constants.USER_PRODUCTS_TABLE, {
        'product_id': productId,
        'product_name': product.name,
        'product_description': product.description,
        'product_image': product.imageUrl,
        'product_price': product.price,
      });

      return true;
    } catch (error) {
      throw error;
    }
  }

  // edit a product
  Future<bool> editProduct(ProductProvider product) async {
    final index = _products.indexWhere((prod) => product.id == prod.id);

    if (index >= 0) {
      final editProductUrl =
          '${Constants.BASE_URL}${Constants.PRODUCTS}/${product
          .id}.json?auth=$token';

      try {
        await http.patch(editProductUrl,
            body: json.encode({
              'name': product.name,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price
            }));

        _products[index] = product;
        notifyListeners();

        _db.update(Constants.USER_PRODUCTS_TABLE, {
          'product_id': product.id,
          'product_name': product.name,
          'product_description': product.description,
          'product_image': product.imageUrl,
          'product_price': product.price,
        });

        return true;
      } catch (error) {
        throw error;
      }
    }
    return false;
  }

  // fetch products
  // here we pass a bool value to determine if we need to fetch all products or
  //just products belong to a specific user id
  Future<List<ProductProvider>> fetchProducts(
      [bool filterByUser = false]) async {
    _isLoading = true;
    final filterOption =
    filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final fetchProductsUrl =
        '${Constants.BASE_URL}${Constants
        .PRODUCTS}.json?auth=$token&$filterOption';

    try {
      final responseData = await http.get(fetchProductsUrl);
      final data = json.decode(responseData.body) as Map<String, dynamic>;
      final List<ProductProvider> fetchedProducts = [];

      if (data == null) {
        _isLoading = false;
        return [];
      };

      if (data.containsKey('error')) {
        _isLoading = false;
        _authProvider.logout();
        return [];
      }

      final starProductUrl =
          '${Constants.BASE_URL}${Constants
          .STARRED_PRODUCTS}/$userId.json?auth=$token';
      final starredResponse = await http.get(starProductUrl);
      final starredData = json.decode(starredResponse.body);

      data.forEach((id, productData) {
        fetchedProducts.add(ProductProvider(
            id: id,
            name: productData['name'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: double.parse(productData['price'].toString()),
            isStarred: starredData == null ? false : starredData[id] ?? false));

        _db.insert(Constants.USER_PRODUCTS_TABLE, {
          'product_id': id,
          'product_name': productData['name'],
          'product_description': productData['description'],
          'product_image': productData['imageUrl'],
          'product_price': double.parse(productData['price'].toString()),
        });
      });

      print(data);
      _products = fetchedProducts;
      notifyListeners();
      _isLoading = false;
    } catch (error) {
      _isLoading = false;
      throw error;
    }

    return _products;
  }

  Future fetchOfflineProducts() async {
    _isLoading = true;
    try {
      final data = await _db.getData('${Constants.USER_PRODUCTS_TABLE}');

      print(data);
      _products = data
          .map((prd) =>
          ProductProvider(
            id: prd['product_id'],
            name: prd['product_name'],
            description: prd['product_description'],
            imageUrl: prd['product_image'],
            price: prd['product_price'],
          ))
          .toList();
      _isLoading = false;
      notifyListeners();

      return;
    } catch (error) {
      _isLoading = false;
      throw error;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    final deleteProductUrl =
        '${Constants.BASE_URL}${Constants
        .PRODUCTS}/$productId.json?auth=$token';

    final index = _products.indexWhere((product) => product.id == productId);
    var product = _products[index];

    _products.removeAt(index);
    notifyListeners();

    final response = await http.delete(deleteProductUrl);

    if (response.statusCode >= 400) {
      //roll back
      _products.insert(index, product);
      notifyListeners();
      throw 'Could not delete the product';
    }

    _db.delete(Constants.USER_PRODUCTS_TABLE, productId);

    product = null;
    imageUrl = null;

    return true;
  }

  /// Upload image file to Firebase Storage and get the url
  /// @Param imageFile: the picked image file ot type File
  /// @Param fileName: name of the file to be uploaded
  Future<void> uploadProductImage(
      {@required File imageFile, @required String fileName}) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('${Constants.FIREBASE_STORAGE_FOLDER}$fileName');

    //upload the file
    final storageUploadTask = storageReference.putFile(imageFile);

    // when completed, try to get the url of the uploaded file
    await storageUploadTask.onComplete.then((_) {
      getUploadedImageUrl(storageReference);
    });
  }

  /// Get uploaded file url by passing Firebase storage reference and notify
  /// edit product screen builders of changes
  Future<void> getUploadedImageUrl(StorageReference storageReference) async {
    await storageReference.getDownloadURL().then((url) {
      imageUrl = url;
      notifyListeners();
    });
  }
}
