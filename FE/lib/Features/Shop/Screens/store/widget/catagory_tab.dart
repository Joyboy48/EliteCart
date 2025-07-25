import 'package:studio_projects/Common/Widgets/Brands/brand_Showcase.dart';
import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:studio_projects/Utiles/HTTP/Brand Service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Features/Shop/Screens/Brand/brand_products.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class CatagoryTab extends StatefulWidget {
  final dynamic category;
  const CatagoryTab({super.key, required this.category});

  @override
  State<CatagoryTab> createState() => _CatagoryTabState();
}

class _CatagoryTabState extends State<CatagoryTab> {
  List brands = [];
  List products = [];
  List brandsInCategory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Helper to normalize category names: trim, lowercase, collapse multiple spaces
  String normalizeCategoryName(String name) {
    return name.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> fetchProducts() async {
    final categoryName =
        normalizeCategoryName((widget.category['name'] ?? '').toString());
    if (categoryName.isEmpty) {
      setState(() {
        products = [];
        brandsInCategory = [];
        isLoading = false;
      });
      return;
    }
    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}/products/category/${widget.category['id'] ?? widget.category['_id']}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Filter products by category name, robust to spaces and case
      final filtered = (data['data'] ?? []).where((p) {
        final categories = p['categories'] as List?;
        if (categories == null) return false;
        return categories
            .any((c) => normalizeCategoryName(c.toString()) == categoryName);
      }).toList();
      // Collect unique brand IDs from these products
      final Set<String> brandIds = filtered
          .map((p) {
            final bId = p['brandId'];
            if (bId == null) return null;
            if (bId is Map && (bId['_id'] != null || bId['id'] != null)) {
              return bId['_id']?.toString() ?? bId['id']?.toString();
            }
            return bId.toString();
          })
          .where((id) => id != null)
          .cast<String>()
          .toSet();
      print('Brand IDs from products: $brandIds');
      // Fetch all brands, then filter to only those in brandIds
      final allBrands = await BrandService.fetchBrands();
      final filteredBrands = allBrands.where((brand) {
        final brandId = brand.id?.toString();
        return brandIds.contains(brandId);
      }).toList();
      setState(() {
        products = filtered;
        brands = allBrands;
        brandsInCategory = filteredBrands;
        isLoading = false;
      });
      for (var brand in allBrands) {
        print('Brand: ${brand.name}, id: ${brand.id}');
      }
    } else {
      setState(() {
        products = [];
        brandsInCategory = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Collect all unique brand IDs from products in this category (as strings)
    final Set<String> categoryBrandIds = products
        .map((p) {
          final bId = p['brandId'];
          if (bId == null) return null;
          if (bId is Map && (bId['_id'] != null || bId['id'] != null)) {
            return bId['_id']?.toString() ?? bId['id']?.toString();
          }
          return bId.toString();
        })
        .where((id) => id != null)
        .cast<String>()
        .toSet();
    print('Unique brand IDs in this category: $categoryBrandIds');
    for (var brand in brands) {
      print('Brand: ${brand.name}, id: ${brand.id}');
    }
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(MySize.defaultSpace),
                child: Column(
                  children: [
                    ///Brands
                    ...brandsInCategory.map((brand) {
                      final brandId = brand.id?.toString();
                      print(
                          'Brand: ${brand.name}, id: ${brand.id}, runtimeType: ${brand.runtimeType}, asMap: $brand');
                      // Find all products for this brand
                      for (var p in products) {
                        print(
                            'Product: ${p['name']}, brandId: ${p['brandId']}, brandIdType: \'${p['brandId']?.runtimeType}\', images: ${p['images']}');
                      }
                      final brandProducts = products.where((p) {
                        final bId = p['brandId'];
                        if (bId is Map &&
                            (bId['_id'] != null || bId['id'] != null)) {
                          return bId['_id']?.toString() == brandId ||
                              bId['id']?.toString() == brandId;
                        } else if (bId is String) {
                          return bId == brandId;
                        }
                        return false;
                      }).toList();

                      final allImages = <String>[];
                      for (var p in brandProducts) {
                        if (p['images'] is List && p['images'].isNotEmpty) {
                          allImages.addAll(List<String>.from(p['images']));
                        }
                      }
                      print(
                          'Collected images for brand ${brand.name}: $allImages');
                      allImages.shuffle();
                      final images = allImages.take(3).toList();

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  BrandProducts(brandId: brandId ?? ''),
                            ),
                          );
                        },
                        child: BrandShowcase(
                          images: images,
                          brandName: brand.name,
                          brandImage: brand.logo,
                          stock: brand.productCount ?? 0,
                        ),
                      );
                    }),
                    const SizedBox(height: MySize.spaceBtwItems),

                    ///Product
                    SectionHeading(
                        title: 'You Might Like',
                        showActionButton: true,
                        onPressed: () {}),
                    const SizedBox(height: MySize.spaceBtwItems),
                    Gridlayout(
                        itemCount: products.length,
                        itemBuilder: (_, index) =>
                            ProductCardVertical(product: products[index])),
                    const SizedBox(height: MySize.spaceBtwSection),
                  ],
                ),
              ),
            ],
          );
  }
}
