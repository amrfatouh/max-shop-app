import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String errorMessage(String error) {
    if (error == 'EMAIL_NOT_FOUND')
      return 'Entered email does not exist';
    else if (error == 'INVALID_PASSWORD')
      return 'Incorrect Password';
    else if (error == 'USER_DISABLED')
      return 'This user has been disabled by the admin';
    else if (error == 'EMAIL_EXISTS')
      return 'This email is already in use';
    else if (error == 'OPERATION_NOT_ALLOWED')
      return 'Not allowed process';
    else if (error == 'TOO_MANY_ATTEMPTS_TRY_LATER')
      return 'Blocked due to unusual activity';
    return 'Authentication error';
  }

  Future<void> showErrorDialogue(BuildContext context, String error) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                errorMessage(error.toString()),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop App')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -pi / 32,
              child: Card(
                elevation: 10,
                shadowColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SHOP APP',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 3,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: !_isSignUp
                    ? MediaQuery.of(context).size.height * 0.38
                    : MediaQuery.of(context).size.height * 0.52,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          } else if (!value.contains('@') ||
                              !value.contains('.')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 6) {
                            return 'Enter 6 characters at least';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (_isSignUp)
                            _confirmPasswordFocusNode.requestFocus();
                        },
                      ),
                      if (_isSignUp) SizedBox(height: 10),
                      if (_isSignUp)
                        TextFormField(
                          focusNode: _confirmPasswordFocusNode,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value.length < 6) {
                              return 'Enter 6 characters at least';
                            } else if (value != _passwordController.text) {
                              return 'The two passwords don\'t match';
                            }
                            return null;
                          },
                        ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_isSignUp)
                              ElevatedButton(
                                child: Text('Sign in'),
                                onPressed: () async {
                                  if (!_formKey.currentState.validate()) return;
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  try {
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .signin(email, password);
                                    Navigator.of(context).pushReplacementNamed(
                                        ProductsOverviewScreen.routeName);
                                  } catch (error) {
                                    showErrorDialogue(
                                      context,
                                      error.toString(),
                                    );
                                  }
                                },
                              ),
                            if (_isSignUp)
                              ElevatedButton(
                                child: Text('Sign up'),
                                onPressed: () async {
                                  if (!_formKey.currentState.validate()) return;
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  try {
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .signup(email, password);
                                    Navigator.of(context).pushReplacementNamed(
                                        ProductsOverviewScreen.routeName);
                                  } catch (error) {
                                    showErrorDialogue(
                                      context,
                                      error.toString(),
                                    );
                                  }
                                },
                              ),
                            SizedBox(width: 10),
                            Text('Or'),
                            if (!_isSignUp)
                              TextButton(
                                onPressed: () {
                                  setState(() => _isSignUp = true);
                                },
                                child: Text('Sign up'),
                              ),
                            if (_isSignUp)
                              TextButton(
                                onPressed: () {
                                  setState(() => _isSignUp = false);
                                },
                                child: Text('Sign in'),
                              ),
                            Text('instead.'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
