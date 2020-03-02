import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_shop_app/providers/auth_provider.dart';
import 'package:flutter_ebook_shop_app/providers/auth_mode.dart';
import 'package:flutter_ebook_shop_app/ui/widgets/progress_bar.dart';
import 'package:flutter_ebook_shop_app/values/strings.dart';
import 'package:provider/provider.dart';
import '../../values/dimens.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class AuthCardWidget extends StatefulWidget {
  @override
  State createState() => _AuthCardWidgetState();
}

class _AuthCardWidgetState extends State<AuthCardWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LOGIN;
  Map<String, String> _authData = {'email': '', 'password': ''};

  final _passwordController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  //Confirm password for signup mode animation
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  AnimationController _animationController;

  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //card - login & signup
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: Dimens.ELEVATION,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: _authMode == AuthMode.SIGNUP
                  ? Dimens.SIGNUP_HEIGHT
                  : Dimens.LOGIN_HEIGHT,
              constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.SIGNUP
                      ? Dimens.SIGNUP_HEIGHT
                      : Dimens.LOGIN_HEIGHT),
              width: deviceScreen.width * 0.75,
              padding: EdgeInsets.all(Dimens.PADDING_16),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //email input
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: Strings.EMAIL_HINT),
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return Strings.INVALID_EMAIL_ERROR;
                          }
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                      //password input
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: Strings.PASSWORD_HINT),
                        obscureText: true,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        onFieldSubmitted: (value) {
                          if (_authMode == AuthMode.SIGNUP)
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return Strings.SHORT_PASSWORD_ERROR;
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                      //confirm password for signup
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        constraints: BoxConstraints(
                            minHeight: _authMode == AuthMode.SIGNUP ? 40 : 0,
                            maxHeight: _authMode == AuthMode.SIGNUP
                                ? 60
                                : 0), //BoxConstraints
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Strings.CONFIRM_PASSWORD_HINT),
                              obscureText: true,
                              focusNode: _confirmPasswordFocusNode,
                              validator: _authMode == AuthMode.SIGNUP
                                  ? (value) {
                                      if (value != _passwordController.text) {
                                        return Strings
                                            .UNMATCHED_PASSWORDS_ERROR;
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      //some space
                      SizedBox(height: Dimens.CUSTOM_HEIGHT_20),
                      //if loading, show indicator, otherwise, show login/signup based on the chosen mode
                      if (_isLoading)
                        ProgressBar()
                      else
                        RaisedButton(
                            child: Text(_authMode == AuthMode.LOGIN
                                ? Strings.LOGIN_LABEL
                                : Strings.SIGNUP_LABEL),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimens.PADDING_16,
                                horizontal: Dimens.PADDING_30),
                            color: Theme.of(context).accentColor,
                            textColor:
                                Theme.of(context).primaryTextTheme.button.color,
                            onPressed: _submit),
                      //some space
                      SizedBox(height: Dimens.CUSTOM_HEIGHT_20),
                      //sign up or login instead action button
                      FlatButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                            '${_authMode == AuthMode.LOGIN ? Strings.SIGNUP_LABEL : Strings.LOGIN_LABEL} instead'),
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimens.PADDING_16,
                            horizontal: Dimens.PADDING_30),
                      )
                    ],
                  )),
            ),
          ),

          //some space
          SizedBox(height: Dimens.CUSTOM_HEIGHT_10),
          //social media area
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  Strings.CONTINUE_WITH,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).accentTextTheme.body1.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Dimens.MARGIN_16),
                _signInWithGoogle()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _signInWithGoogle() {
    return OutlineButton(
      splashColor: Theme.of(context).primaryColor,
      onPressed: () async{
        await Provider.of<AuthProvider>(context, listen: false)
            .signInWithGoogle().then((value){
          setState(() {
            _isLoading = false;
          });
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 0,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 28.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 16,

                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // switch between login and signup
  void _switchAuthMode() {
    if (_authMode == AuthMode.LOGIN) {
      setState(() {
        _authMode = AuthMode.SIGNUP;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.LOGIN;
      });
      _animationController.reverse();
    }
  }

  // submit data for login or signup
  Future<void> _submit() async {
    //.validate returns true if there is no errors during validation
    if (!_formKey.currentState.validate()) {
      //invalid input data
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.LOGIN) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(email: _authData['email'], password: _authData['password']);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signup(email: _authData['email'], password: _authData['password']);
      }
    } catch (error) {
      var errorMessage = 'Authenticate failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }

      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => _alertDialog(message)

    );
  }

  Widget _alertDialog(String message){
    if(Platform.isAndroid){
      return AlertDialog(
        title: Text(Strings.ERROR),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Strings.OK))
        ],
      );
    }else{
      return AlertDialog(
        title: Text(Strings.ERROR),
        content: Text(message),
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
