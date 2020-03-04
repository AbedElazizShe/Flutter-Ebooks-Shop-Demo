# Flutter e-books Shop Demo

A multi-pages mobile app built in Flutter for both Android and iOS platforms. It used Flutter Provider package for state management and implements Firebase Authentication, Realtime database, and Storage.

## Getting Started
E-book Shop is a multi-pages mobile app built in Flutter for both Android and iOS platforms. The purpose of this project is to provide a starting point for developers who want to start building applications in Flutter for mobile and who prefer to learn programming languages by example.

This example contains important features that majority of apps require such as; handling Http requests and responses, run-time permissions, data persistence using SQLite, items lists and grids, checking for internet connectivity and listening to connection state changes, picking images from gallery, managing the state of the app, and how to use different widgets provided by Flutter which are platform-specific to help building beautiful applications in no time.

In this project, Firebase authentication, database, and storage are used for simplicity as these services are provided free of charge. If you have your own web server and APIs, you can make the necessary changes to what suits your requirement, however, the general approach of handling these APIs should be somehow similar.

## Demo
![Demo](/ss/demo.gif)

## Screenshots

Light             |  Dark
:-------------------------:|:-------------------------:
![image](/ss/android_login_light.png)    |  ![image](/ss/android_login_dark.png)
![image](/ss/android_home_light.png)     |  ![image](/ss/android_home_dark.png)
![image](/ss/android_orders_light.png)   |  ![image](/ss/android_orders_dark.png)
![image](/ss/android_products_light.png) |  ![image](/ss/android_products_dark.png)
![image](/ss/android_settings_light.png) |  ![image](/ss/android_settings_dark.png)
![image](/ss/android_cart_light.png)     |  ![image](/ss/android_add_prod_dark.png)
![image](/ss/ios_settings_light.png)     |  ![image](/ss/ios_login_dark.png)
![image](/ss/ios_add_product_light.png)  |  ![image](/ss/ios_home_dark.png)


## Widgets
Flutter is all about widgets. It is important to have a look at [Flutter widgets](https://flutter.dev/docs/development/ui/widgets) Catalog web page to understand what kind of widgets you can use and how to use them. The website provides great documentation with examples on how to build beautiful UIs in Flutter. In addition, [Flutter studio](https://flutterstudio.app/) is a great tool to understand Flutter widgets.

## State Management
Managing the state of your application is a very important process in the app’s lifecycle. In Flutter, there are 2 types of state;

* **Ephemeral state**: which is sometimes called UI or Local state. It can be implemented using State and setState(). This state is often local to a single widget. For example, the selected tab in BottomNavigationBar or loading state to determine whether to show a loading spinner or not.

* **App state**: this state is shared across many parts of the app and what needs to be kept between different sessions. For example, deciding if a user is logged in to keep allowing him to navigate the app or not and maybe redirect him to login page.

The type of the state can be managed simply by deciding who needs the data; if it is just a single widget like showing a spinner, then it is the local state, but if the data is needed in some or most widgets, then it is needed to be the App state.

It is important to mention that widgets in Flutter are immutable, they get replaced instead of being changed. To make working with widgets easier where in Flutter, everything is a widget, the provider pattern is used.

### Providers
Providers are a mixture between Dependency Injection (DI) and state management, it offered the following;

* Change Notifier: it simply provides change notifications to its listeners. In other words, you can subscribe to changes and make the necessary changes upon receiving a change notification. For example, when the user clicks on star icon to favorite/unfavorite an item, we change the value of isStarred and notify a Consumer of the change to rebuild a widget and hence a piece of UI.

```dart
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
        .
        .
        .
void _setStarredValue(bool isStarred){
    this.isStarred = isStarred;
    notifyListeners();
  }

}
```

* Consumer: it allows using the provided model (provider) to a widget. Consumer has a build function that is called every time the ChangeNotifier changes upon NotifyListeners call.  The builder has 3 arguments; context that is provided in every builder method in Flutter, ChangeNotifier, which is what we are looking for, this data is used to determine how the ui should look like, and the third argument is a child.

```dart
import 'package:flutter/material.dart';
        .
        .
        .
    Consumer<ShopProvider>(
                builder: (ctx, productsData, child) =>
                        productsData.products.length == 0
                            ? Center(
                                child: ProgressBar(),
                            )
                            : Padding()
),
        .
        .
        .
```

It is best practise to place the consumer as deep in the widget tree as possible only to wrap what needs to be rebuilt to avoid rebuilding a large portion of the UI which can impact performance. In case the data is not required to change the UI but it is required to access it, we use Provider.of
```dart
 final authProvider = Provider.of<AuthProvider>(context, listen: false);
```

* ChangeNotifierProvider: it is the widget that provides an instance of ChangeNotifier. It is placed above the widget that needs to access it.

```dart
ChangeNotifierProvider(create: (_) => AuthProvider()),
```

## Data Persistence with SQLite

Flutter supports SQLite databases to persist data on local devices. Databases provide faster queries, inserts and updates compared to other data persistence solutions.

In order to use the database, sqflite and path packages are used in this project (look at [pubspec.yaml](/pubspec.yaml)). Before data can be read and written to the database, we have to open a connection to the database by defining the path using the packages and then open the database.

```dart
import 'package:flutter_ebook_shop_app/utils/constants.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

static initDb() async {
    final dbPath = await sql.getDatabasesPath();

    // open if found, create if not found for db
    return sql.openDatabase(path.join(dbPath, 'shop.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE ${Constants.USER_PRODUCTS_TABLE}(product_id TEXT PRIMARY KEY, '
          'product_name TEXT, product_description TEXT, product_image TEXT, product_price REAL)');
    }, version: 1);
  }

```
In this app, user_products table was created where each product has an id, name, description, image url, and price.

The database provides a set of functions to insert, delete, update, and query to read and write data. Refer to [db_helper.dart](/lib/helpers/db_helper.dart).

# Setup and run the app
You can clone or download the project to your machine and open it in Android Studio or any IDE you prefer.

View pubspec.yaml file and click on Packages get if you’re using Android Studio or run
Flutter pub get In terminal to get dependencies.

In order for the app to function, it is important to setup a Firebase project by adding a new project in Firebase console to configure and enable the following;

* **Firebase Authentication**: this project uses Firebase authentication for email/password and Login-with-Google sign in methods. You can do that from console -> Develop->Authentication->Sign-in-method. Click and enable both email/password and Google methods. For complete step by step tutorial to setup Firebase Authentication for both Android and iOS, you can refer to this article on Medium [Flutter: Implementing Google Sign In by Souvik Biswas](https://medium.com/flutter-community/flutter-implementing-google-sign-in-71888bca24ed). Don’t forget to download Google-services.json and and GoogleService-info.plist to replace the existing files in the project directory. Then from Firebase project settings (gear icon in the console), choose Project Settings->General copy Web API key and add it for both login and signup url in constants.dart
```dart
    //Firebase auth api
    static const SIGN_UP_AUTH_URL =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[add_your_key]';
    static const LOG_IN_AUTH_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[add_your_key]';

```

Cross Check: Make sure you added SHA certificate fingerprints to your Android app at Firebase console settings for the used keystore, you can get that value for your debug keystore as follows;

Windows

```
keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
```

Mac/Linux

```
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
```
![image](/ss/firebase_configuration.png)

And visit [this](https://console.developers.google.com/apis/credentials/consent) page. Ensure you are signed in with same account where you have created Firebase project, choose your firebase project from the dropdown menu if it is not already selected and click on **edit app**, then fill up the form. Scroll down to "Authorized domain", copy the link and paste it as the screenshot below shows - don't forget to add http://;

![image](/ss/dev_console.png)

then save.


* **Firebase Realtime Database**: in this project, realtime database is used, from Firebase console, choose Database - below Authentication- and click on Realtime database. When it is created, choose “Data” tab and copy the link then add to BASE_URL in constants.dart
```dart
    static const BASE_URL = '[url_copied_from_realtime_database_Data_tab]';
```
Then click on “Rules” tab and replace the rules with the following;

    {
      "rules": {
        ".read": true,
        ".write": true,
        "products": {
          ".indexOn": ["creatorId"]
        }
      }
    }

These rules are only for a demo project and must not be used for production as there are not secure and open to public. Read [Rules documentation}(https://firebase.google.com/docs/database/security)

* **Firebase Storage**: click on storage in Firebase console, and create a new directory to upload the image to. Copy the name and paste in in FIREBASE_STORAGE_FOLDER inside constants.dart.

```dart
      //Firebase Storage
      static const FIREBASE_STORAGE_FOLDER = '[add_folder_name]/';
```

## Plugins
| Name | Usage |
|------|-------|
|[**google_sign_in**](https://pub.dev/packages/google_sign_in)| Login with google|
|[**firebase_auth**](https://pub.dev/packages/firebase_auth)| To use Firebase Authentication API|
|[**Provider**](https://pub.dev/packages/provider)| State Management|
|[**http**](https://pub.dev/packages/http)| To make HTTP requests|
|[**shared_preferences**](https://pub.dev/packages/shared_preferences)| Simple data persistent store|
|[**sqflite**](https://pub.dev/packages/sqflite)| SQLite plugin|
|[**image_picker**](https://pub.dev/packages/image_picker)| To pick images from the image library|
|[**path_provider**](https://pub.dev/packages/path_provider)| To find commonly used locations on the filesystem|
|[**firebase_storage**](https://pub.dev/packages/firebase_storage)| To use Firebase Cloud Storage API|
|[**connectivity**](https://pub.dev/packages/firebase_storage)| To discover network connectivity|
|[**intl**](https://pub.dev/packages/intl)| To provide date formatting|

## Getting help
For questions, suggestions, or anything else, email elaziz.shehadeh(at)gmail.com

## Credits
* [Learn Flutter & Dart to Build iOS & Android Apps [2020] ](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
* [Flutter: Implementing Google Sign In](https://medium.com/flutter-community/flutter-implementing-google-sign-in-71888bca24ed)