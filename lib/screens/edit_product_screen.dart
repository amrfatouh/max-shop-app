import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:http/http.dart' as http;

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';
  const EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _product;
  bool _isLoading = false;
  String imageUrl = '';
  bool _imageSet = false;

  Future<bool> isValidUrl(String url) async {
    // print(imageUrl.isEmpty);
    // print(!imageUrl.contains('http://'));
    // print(!imageUrl.contains('https://'));
    if (imageUrl.isEmpty ||
        (!imageUrl.contains('http://') && !imageUrl.contains('https://')))
      return false;
    final response = await http.get(Uri.parse(url));
    // print(response.statusCode);
    return response.statusCode == 200;
  }


  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() async {
    setState(() => _isLoading = true);
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      setState(() => _isLoading = false);
      return;
    }
    _form.currentState.save();
    try {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_product);
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error ocurred!'),
                content: Text('Something went wrong'),
                actions: [
                  TextButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }
    setState(() => _isLoading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _product = ModalRoute.of(context).settings.arguments;
    if (!_imageSet) {
      _imageUrlController.text = _product.imageUrl;
      setState(() => imageUrl = _product.imageUrl);
      _imageSet = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: Column(
            children: [
              // title
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                initialValue: _product.title,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _product.title = value;
                },
                validator: (value) {
                  if (value.isEmpty) return 'Title is required';
                  return null;
                },
              ),
              // price
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                initialValue: _product.price.toStringAsFixed(2),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                onSaved: (value) {
                  _product.price = double.parse(value);
                },
                validator: (value) {
                  if (value.isEmpty) return 'Price is required';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid price';
                  if (double.parse(value) <= 0) return 'Enter a positive value';
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
              child: FutureBuilder(
                            future: isValidUrl(imageUrl),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data == true)
                                  return Image.network(imageUrl);
                                else
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                child: Text(
                                  'can\'t preview image',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                    ),
                    decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                              color: Colors.blue.shade200,
                      ),
                    ),
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    // imageUrl
                    child: Focus(
                            onFocusChange: (hasFocus) {
                              if (!hasFocus)
                                setState(() {
                                  imageUrl = _imageUrlController.text;
                                });
                            },
                      child: TextFormField(
                              controller: _imageUrlController,
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _product.imageUrl = value;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Image Url is required';
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https'))
                                  return 'Enter a valid URL';
                                return null;
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
