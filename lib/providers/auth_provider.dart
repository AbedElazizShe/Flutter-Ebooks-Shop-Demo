import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_shop_app/helpers/db_helper.dart';
import 'package:flutter_ebook_shop_app/style/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _token;
  String _userId;

  ThemeData theme = lightTheme;
  Key key = UniqueKey();

  AuthProvider() {
    checkAppTheme();
  }

  bool get isLoggedIn => _token != null;
  String get token => _token;
  String get userId => _userId;

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  //Login
  Future<bool> login({@required email, @required password}) async {
    return _authenticate(
        email: email, password: password, url: Constants.LOG_IN_AUTH_URL);
  }

  //Sign-up
  Future<bool> signup({@required email, @required password}) async {
    return _authenticate(
        email: email, password: password, url: Constants.SIGN_UP_AUTH_URL);
  }

  //Authentication
  Future<bool> _authenticate(
      {@required email, @required password, @required url}) async {
    try {
      //Refer to firebase auth api for documentation
      final response = await http
          .post(url,
              body: json.encode({
                'email': email,
                'password': password,
                'returnSecureToken': true
              }))
          .catchError((error) {
        throw error;
      });

      final responseData = json.decode(response.body);

      if (responseData['error'] != null)
        throw (responseData['error']['message']);

      _token = responseData['idToken'];
      _userId = responseData['localId'];

      print('Response data body $responseData');

      notifyListeners();

      //Save to shared preferences
      _saveUserData(false);

      return true;
    } catch (error) {
      throw error.toString();
    }
  }

  //Try to auto login
  Future<bool> tryAutoLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey('userData')) return false;

    final userData = json.decode(sharedPreferences.getString('userData'))
        as Map<String, Object>;

    _token = userData['token'];
    _userId = userData['userId'];

    notifyListeners();

    return true;
  }

  //Logout
  void logout() async {
    _token = null;
    _userId = null;

    await SharedPreferences.getInstance().then((prefs) async {
      final userData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      // when login type is login-with-google, sign out that session
      if (userData['loginType']) {
        await googleSignIn.signOut();
      }

      // Clear both db and sharedPreferences data and notify changes
      final db = DBHelper();
      db.clear();
      prefs.clear();
      notifyListeners();
    });
  }

  //Save user details after a successful login
  void _saveUserData(bool isSocialLogin) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = json.encode(
        {'token': _token, 'userId': _userId, 'loginType': isSocialLogin});
    sharedPreferences.setString('userData', userData);
  }

  //Login with Google
  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    await user.getIdToken().then((token) {
      _token = token.token;
    });
    _userId = user.uid;

    notifyListeners();

    _saveUserData(true);

    return true;
  }

  // Another provider can be created to handle theme related code. For this demo
  // defining it here is fine
  void setTheme(value, isLight) {
    theme = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("isLight", isLight).then((val) {
      });
    });
    notifyListeners();
  }

  ThemeData get getTheme => theme;

  // Check if app theme is light or dark and change app ui accordingly
  Future<ThemeData> checkAppTheme() async {
    final prefs = await SharedPreferences.getInstance();
    ThemeData themeData;
    bool isLight =
        prefs.getBool('isLight') == null ? true : prefs.getBool('isLight');

    if (isLight) {
      themeData = lightTheme;
      setTheme(lightTheme, true);
    }else{
      themeData = darkTheme;
      setTheme(darkTheme, false);
    }

    return themeData;
  }
}
