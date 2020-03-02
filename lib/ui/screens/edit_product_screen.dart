import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/product_provider.dart';
import 'package:flutter_ebook_shop_app/providers/shop_provider.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/progress_bar.dart';
import 'package:flutter_ebook_shop_app/values/dimens.dart';
import 'package:flutter_ebook_shop_app/values/strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class EditProductScreen extends StatefulWidget {
  static const START = '/edit-product-screen';

  @override
  State createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _isInit = true;

  var _initValues = {
    'name': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isLoading = false;

  var _editedProduct = ProductProvider(
      id: null, name: '', description: '', imageUrl: '', price: 0.0);

  var _pageType = -1;

  // Pick a picture form device's gallery
  Future<void> _takePicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);

    final savedImage = await image.copy('${appDir.path}/$fileName');

    _uploadImage(savedImage, fileName);
  }

  // Upload the image to Firebase Storage
  Future<void> _uploadImage(File savedImage, String fileName) async {
    await Provider.of<ShopProvider>(context, listen: false)
        .uploadProductImage(imageFile: savedImage, fileName: fileName);
  }

  // Add a new product
  Future<void> _addProduct() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id == null) {
      // New product
      await Provider.of<ShopProvider>(context, listen: false)
          .addNewProduct(_editedProduct);
    } else {
      // Existing product to be edited
      try {
        await Provider.of<ShopProvider>(context, listen: false)
            .editProduct(_editedProduct);
      } catch (error) {
        await showDialog(context: context, builder: (_) => _alertDialog());
      }
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final route =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      final productId = route['productId'].toString();
      _pageType = route['pageType'];

      if (productId.isNotEmpty) {
        _editedProduct =
            Provider.of<ShopProvider>(context).findProductById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_pageType == 0 ? 'Add Product' : 'Edit Product'),
        actions: <Widget>[
          _isLoading
              ? Container(
                  child: SizedBox(
                    child: ProgressBar(),
                    height: 20,
                    width: 20,
                  ),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 16.0),
                )
              : Platform.isAndroid
                  ? IconButton(
                      icon: Icon(Icons.done),
                      padding: EdgeInsets.zero,
                      onPressed: _addProduct)
                  : CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Tooltip(
                        message: 'Done',
                        child:
                            Text('Done', style: TextStyle(color: Colors.white)),
                        excludeFromSemantics: true,
                      ),
                      onPressed: _addProduct)
        ],
      ),
      body: _isLoading
          ? Center(
              child: ProgressBar(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //Product Image
                  Container(
                    margin: const EdgeInsets.all(Dimens.MARGIN_16),
                    alignment: Alignment.topCenter,
                    height: 250,
                    width: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        Consumer<ShopProvider>(builder: (ctx, provider, _) {
                          _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              name: _editedProduct.name,
                              description: _editedProduct.description,
                              imageUrl: provider.imageUrl != null
                                  ? provider.imageUrl
                                  : _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isStarred: _editedProduct.isStarred);

                          return Container(
                              height: 220,
                              width: 220,
                              child: CircleAvatar(
                                  backgroundImage: _editedProduct
                                          .imageUrl.isNotEmpty
                                      ? NetworkImage(provider.imageUrl == null
                                          ? _editedProduct.imageUrl
                                          : provider.imageUrl)
                                      : AssetImage(
                                          'assets/images/placeholder_square.jpg')));
                        }),
                        Positioned(
                          bottom: 10,
                          right: 20,
                          child: FloatingActionButton(
                              child: Icon(
                                Icons.photo_album,
                                color: Colors.white,
                              ),
                              onPressed: _takePicture),
                        )
                      ],
                    ),
                  ),
                  //Form/product details
                  Padding(
                      padding: const EdgeInsets.all(Dimens.MARGIN_16),
                      child: Form(
                        key: _form,
                        child: Container(
                          padding: const EdgeInsets.all(Dimens.MARGIN_08),
                          child: Column(
                            children: <Widget>[
                              //product name
                              TextFormField(
                                initialValue: _initValues['name'],
                                decoration: InputDecoration(
                                    labelText: 'Product name',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_priceFocusNode);
                                },
                                validator: (value) {
                                  if (value.isEmpty) return Strings.EMPTY_FIELD;
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = ProductProvider(
                                      id: _editedProduct.id,
                                      name: value,
                                      description: _editedProduct.description,
                                      imageUrl: _editedProduct.imageUrl,
                                      price: _editedProduct.price,
                                      isStarred: _editedProduct.isStarred);
                                },
                              ),
                              SizedBox(
                                height: Dimens.MARGIN_16,
                              ),
                              //product price
                              TextFormField(
                                initialValue: _initValues['price'],
                                decoration: InputDecoration(
                                    labelText: 'Price',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: _priceFocusNode,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_descriptionFocusNode);
                                },
                                validator: (value) {
                                  if (value.isEmpty) return Strings.EMPTY_FIELD;
                                  if (double.parse(value) == null)
                                    return Strings.INVALID_NUMBER;
                                  if (double.parse(value) <= 0)
                                    return Strings.INVALID_NUMBER_2;
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = ProductProvider(
                                      id: _editedProduct.id,
                                      name: _editedProduct.name,
                                      description: _editedProduct.description,
                                      imageUrl: _editedProduct.imageUrl,
                                      price: double.parse(value),
                                      isStarred: _editedProduct.isStarred);
                                },
                              ),
                              SizedBox(
                                height: Dimens.MARGIN_16,
                              ),
                              //product description
                              TextFormField(
                                initialValue: _initValues['description'],
                                decoration: InputDecoration(
                                    labelText: 'Product desription',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                focusNode: _descriptionFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) return Strings.EMPTY_FIELD;
                                  if (value.length < 15)
                                    return Strings.SHORT_DESCRIPTION;
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = ProductProvider(
                                      id: _editedProduct.id,
                                      name: _editedProduct.name,
                                      description: value,
                                      imageUrl: _editedProduct.imageUrl,
                                      price: _editedProduct.price,
                                      isStarred: _editedProduct.isStarred);
                                },
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
    );
  }

  Widget _alertDialog() {
    if (Platform.isAndroid) {
      return AlertDialog(
        title: Text('An error occurred!'),
        content: Text('Something went wrong!'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Strings.OK))
        ],
      );
    } else {
      return AlertDialog(
        title: Text('An error occurred!'),
        content: Text('Something went wrong!'),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Strings.OK))
        ],
      );
    }
  }
}
