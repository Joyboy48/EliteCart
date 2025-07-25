import 'package:flutter/material.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Details/widgets/bottom_add_to_cart.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Details/widgets/product_attributes.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Details/widgets/product_image_detail.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Details/widgets/product_meta_data.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Details/widgets/rating_share_widget.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Review/product_review.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Features/Shop/Controller/wishlist_controller.dart';
import 'package:studio_projects/Features/Shop/Screens/order/checkout_screen.dart';
import 'package:studio_projects/Utiles/local_storage/storage_utility.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  dynamic product;
  bool isLoading = true;
  final WishlistController wishlistController = Get.find<WishlistController>();
  double avgRating = 0.0;
  int reviewCount = 0;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}/products/product/${widget.productId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        product = data;
        avgRating = (data['rating'] ?? 0.0).toDouble();
        reviewCount = (data['reviews'] is List)
            ? data['reviews'].length
            : (data['reviewCount'] ?? 0);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (product == null) return const Center(child: Text('Product not found'));
    final productId = product['_id']?.toString() ?? '';
    return Scaffold(
      bottomNavigationBar: BottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///Product image slider
            ProductImageSlider(product: product),

            ///product image
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: MySize.defaultSpace,
                    left: MySize.defaultSpace,
                    bottom: MySize.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///Rating and Share
                    RatingandShare(
                      product: product,
                      avgRating: avgRating,
                      reviewCount: reviewCount,
                    ),
                    SizedBox(
                      height: MySize.spaceBtwItems / 2,
                    ),

                    ///Price title
                    ProductMetaData(product: product),
                    SizedBox(
                      height: MySize.spaceBtwItems / 2,
                    ),

                    ///attribute
                    ProductAttributes(product: product),
                    const SizedBox(
                      height: MySize.spaceBtwSection,
                    ),

                    ///Checkout button
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              final token = await LocalStorage().getToken();
                              if (token == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please log in to proceed to checkout.')),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(
                                    cartProducts: [product],
                                    total:
                                        (product['price'] as num?)?.toInt() ??
                                            0,
                                  ),
                                ),
                              );
                            },
                            child: const Text('CheckOut'))),
                    const SizedBox(
                      height: MySize.spaceBtwItems,
                    ),

                    ///Description
                    const SectionHeading(
                      title: 'Description',
                      showActionButton: false,
                    ),
                    const SizedBox(
                      height: MySize.spaceBtwItems,
                    ),
                    ReadMoreText(
                      product['description'] ?? '',
                      trimLines: 4,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Less',
                      moreStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800),
                      lessStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800),
                    ),

                    ///Reviewe
                    SizedBox(
                      height: MySize.spaceBtwItems / 2,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: MySize.spaceBtwItems,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionHeading(
                          title: 'Reviews ($reviewCount)',
                          showActionButton: false,
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.arrow_right_3, size: 18),
                          onPressed: () async {
                            await Get.to(
                                () => ProductReview(productId: productId));
                            fetchProduct();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: MySize.spaceBtwSection,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
