import 'package:get/get.dart';
import 'package:studio_projects/Utiles/HTTP/cart_service.dart';

class CartItem {
  final String productId;
  int quantity;
  double price;
  CartItem(
      {required this.productId, required this.quantity, required this.price});
}

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxDouble totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final data = await CartService.getCart();
      _cartItems.clear();
      for (var item in data['items']) {
        _cartItems.add(CartItem(
          productId: item['productId'] is Map
              ? item['productId']['_id']
              : item['productId'],
          quantity: item['quantity'],
          price: (item['price'] as num).toDouble(),
        ));
      }
      totalAmount.value = (data['totalAmount'] ?? 0).toDouble();
    } catch (e) {
      // handle error
    }
  }

  Future<void> addToCart(String productId, int quantity, double price) async {
    try {
      final data = await CartService.addToCart(productId, quantity, price);
      await fetchCart();
    } catch (e) {
      // handle error
    }
  }

  Future<void> updateCartItem(String productId, int quantity) async {
    try {
      final data = await CartService.updateCartItem(productId, quantity);
      await fetchCart();
    } catch (e) {
      // handle error
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final data = await CartService.removeFromCart(productId);
      await fetchCart();
    } catch (e) {
      // handle error
    }
  }

  Future<void> clearCart() async {
    try {
      final data = await CartService.clearCart();
      await fetchCart();
    } catch (e) {
      // handle error
    }
  }

  // Clear cart data locally (for logout)
  void clearCartLocal() {
    _cartItems.clear();
    totalAmount.value = 0.0;
  }

  RxList<CartItem> get cartItems => _cartItems;

  int getQuantity(String productId) =>
      _cartItems
          .firstWhereOrNull((item) => item.productId == productId)
          ?.quantity ??
      0;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
}
