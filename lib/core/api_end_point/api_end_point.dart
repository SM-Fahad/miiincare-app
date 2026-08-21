class ApiEndPoint {
  static const String baseUrl = 'https://api.miiincare.com/api';
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/categories';
  static const String cart = '$baseUrl/cart';
  static const String cartItems = '$cart/items';
  static const String orders = '$baseUrl/orders';
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String profile = '$baseUrl/auth/me';
  static const String homeContent = '$baseUrl/content/home';

  static String product(String slug) => '$products/$slug';
  static String reviews(String slug) => '${product(slug)}/reviews';
  static String cartItem(String id) => '$cartItems/$id';
  static String order(String id) => '$orders/$id';
}
