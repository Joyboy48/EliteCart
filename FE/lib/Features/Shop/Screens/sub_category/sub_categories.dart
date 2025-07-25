import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/images/rounded_images.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_horizontal.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/images/rounded_images.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_horizontal.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class SubCategoriesScreen extends StatefulWidget {
  final dynamic category; // Accept category object or just categoryId
  const SubCategoriesScreen({super.key, required this.category});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final categoryName = widget.category['name'];
    if (categoryName == null) {
      setState(() {
        products = [];
        isLoading = false;
      });
      return;
    }
    final response =
        await http.get(Uri.parse(ApiConstants.baseUrl + "/products/products"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final allProducts = data['data'] ?? [];
      final filtered = allProducts
          .where((p) => (p['categories'] as List).any((c) => c
              .toString()
              .toLowerCase()
              .contains(categoryName.toString().toLowerCase())))
          .toList();
      filtered.shuffle();
      setState(() {
        products = filtered;
        isLoading = false;
      });
    } else {
      setState(() {
        products = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(
          widget.category['name'] ?? '',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySize.defaultSpace),
          child: Column(
            children: [
              ///Banner
              RoundedImage(
                imageUrl: ImageStrings.banner3,
                width: double.infinity,
                height: null,
                applyImageRadius: true,
              ),
              const SizedBox(
                height: MySize.spaceBtwSection,
              ),

              ///sub category
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeading(
                    title: widget.category['name'] ?? 'Products',
                    showActionButton: false,
                  ),
                  const SizedBox(height: MySize.spaceBtwItems / 2),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: MySize.spaceBtwItems),
                    itemBuilder: (context, index) =>
                        ProductCardHorizontal(product: products[index]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
