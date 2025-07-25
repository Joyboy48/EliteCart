import 'package:get/get.dart';
import 'package:studio_projects/Utiles/HTTP/wishlist_service.dart';

class WishlistController extends GetxController {
  // Set of product IDs in the wishlist
  final RxSet<String> _wishlistProductIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      final items = await WishlistService.getWishlist();
      _wishlistProductIds.clear();
      for (var item in items) {
        final productId = item['productId'] is Map
            ? item['productId']['_id']
            : item['productId'];
        _wishlistProductIds.add(productId);
      }
    } catch (e) {
      // handle error
    }
  }

  Future<void> addToWishlist(String productId) async {
    try {
      await WishlistService.addToWishlist(productId);
      await fetchWishlist();
    } catch (e) {
      // handle error
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await WishlistService.removeFromWishlist(productId);
      await fetchWishlist();
    } catch (e) {
      // handle error
    }
  }

  // Check if product is in wishlist
  bool isWishlisted(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  // Get all wishlisted product IDs
  Set<String> get wishlistProductIds => _wishlistProductIds;

  Future<void> toggleWishlist(String productId) async {
    try {
      await WishlistService.toggleWishlist(productId);
      await fetchWishlist();
    } catch (e) {
      // handle error
    }
  }

  // Clear wishlist data (for logout)
  void clearWishlist() {
    _wishlistProductIds.clear();
    update();
  }
}
