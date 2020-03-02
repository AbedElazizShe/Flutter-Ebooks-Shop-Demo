class Constants {
  //TODO replace values with your own
  static const BASE_URL = '[url_copied_from_realtime_database_Data_tab]';

  //Firebase auth api
  static const SIGN_UP_AUTH_URL =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[add_your_key]';
  static const LOG_IN_AUTH_URL =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[add_your_key]';

  //Products
  static const PRODUCTS = 'products';
  static const STARRED_PRODUCTS = 'starred';
  static const ORDERS = 'orders';

  //Firebase Storage
  static const FIREBASE_STORAGE_FOLDER = '[add_folder_name]/';

  // DB name
  static const USER_PRODUCTS_TABLE = 'user_products';
}
