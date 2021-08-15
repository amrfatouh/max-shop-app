import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';
  const EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _product;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    bool isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    Provider.of<Products>(context, listen: false).updateProduct(_product);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _product = ModalRoute.of(context).settings.arguments;
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
      body: Padding(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Text(
                      'image preview',
                      softWrap: true,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    // imageUrl
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      initialValue: _product.imageUrl,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _product.imageUrl = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Image Url is required';
                        if (!value.startsWith('http') &&
                            !value.startsWith('https'))
                          return 'Enter a valid URL';
                        return null;
                      },
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
