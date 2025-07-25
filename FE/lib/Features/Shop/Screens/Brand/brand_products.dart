import 'package:studio_projects/Common/Widgets/Brands/brand_Card.dart';
import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/products/sortable/sortable_product.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:studio_projects/Utiles/HTTP/Brand Service.dart';
import 'package:studio_projects/Features/Shop/Models/band.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';
class BrandProducts extends StatefulWidget {
  final String brandId;
  const BrandProducts({super.key, required this.brandId});

  @override
  State<BrandProducts> createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  String brandName = '';
  String brandImage = '';
  int stock = 0;
  bool isLoading = true;
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchBrandAndProducts();
  }

  Future<void> fetchBrandAndProducts() async {
    final brands = await BrandService.fetchBrands();
    Brand? brand;
    try {
      brand = brands.firstWhere((b) => b.id == widget.brandId);
    } catch (_) {
      brand = null;
    }
    if (brand != null) {
      // Fetch all products
      final response = await http
          .get(Uri.parse(ApiConstants.baseUrl + "/products/products"));
      List filteredProducts = [];
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final allProducts = data['data'] ?? [];
        filteredProducts = allProducts.where((p) {
          final bId = p['brandId'];
          if (bId is Map && bId['_id'] != null) {
            return bId['_id'] == widget.brandId;
          } else if (bId is String) {
            return bId == widget.brandId;
          }
          return false;
        }).toList();
      }
      setState(() {
        brandName = brand!.name;
        brandImage = brand!.logo;
        stock = brand!.productCount ?? 0;
        products = filteredProducts;
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
    return Scaffold(
      appBar: MyAppBar(
        title: Text(brandName.isNotEmpty ? brandName : 'Brand'),
        showBackArrow: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(MySize.defaultSpace),
                child: Column(
                  children: [
                    ///Brand Detail
                    BrandCard(
                      showBorder: true,
                      brandName: brandName,
                      brandImage: brandImage,
                      stock: stock,
                    ),
                    SizedBox(height: MySize.spaceBtwSection),
                    // Display only products of this brand
                    products.isEmpty
                        ? const Text('No products found for this brand')
                        : Gridlayout(
                            itemCount: products.length,
                            itemBuilder: (context, index) =>
                                ProductCardVertical(product: products[index]),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
