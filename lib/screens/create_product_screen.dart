import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class CreateProductScreen extends StatefulWidget {
  static String routeName = '/create-product';
  const CreateProductScreen({Key key}) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _product = Product();

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
    _product.id = "Product_${DateTime.now().toIso8601String()}";
    Provider.of<Products>(context, listen: false).addProduct(_product);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
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
