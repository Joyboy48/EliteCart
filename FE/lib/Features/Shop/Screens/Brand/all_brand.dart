import 'package:studio_projects/Common/Widgets/Brands/brand_Card.dart';
import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/sortable/sortable_product.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Features/Shop/Screens/Brand/brand_products.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studio_projects/Utiles/HTTP/Brand Service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';

class AllBrandScreen extends StatefulWidget {
  const AllBrandScreen({super.key});

  @override
  State<AllBrandScreen> createState() => _AllBrandScreenState();
}

class _AllBrandScreenState extends State<AllBrandScreen> {
  List brands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      final result = await BrandService.fetchBrands();
      setState(() {
        brands = result;
        brands.shuffle();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: Text('Brands'), showBackArrow: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(MySize.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SectionHeading(
                          title: 'Brands', showActionButton: false),
                      const SizedBox(height: MySize.spaceBtwItems),
                      Gridlayout(
                        itemCount: brands.length,
                        mainAxisExtent: 80,
                        itemBuilder: (context, index) => BrandCard(
                          showBorder: true,
                          brandName: brands[index].name ?? '',
                          brandImage: brands[index].logo ?? '',
                          stock: brands[index].productCount ??
                              0, // or brands[index].stock
                          onTap: () => Get.to(
                              () => BrandProducts(brandId: brands[index].id)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
