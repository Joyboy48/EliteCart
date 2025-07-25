import 'package:studio_projects/Common/Widgets/Brands/brand_Card.dart';
import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/appBar/tabBar.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/search_container.dart';
import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/cart/cart_menu_icon.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Features/Shop/Screens/Brand/all_brand.dart';
import 'package:studio_projects/Features/Shop/Screens/store/widget/catagory_tab.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Utiles/HTTP/Brand Service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Features/Shop/Screens/Brand/brand_products.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  List<dynamic> categories = [];
  bool isLoading = true;
  List brands = [];
  bool isBrandLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final res = await http
        .get(Uri.parse(ApiConstants.baseUrl + "/categories/categories"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        categories = data['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> searchBrands(String query) async {
    setState(() {
      isBrandLoading = true;
    });
    final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + "/brands/brands/search?q=$query"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        brands = data['data'];
        isBrandLoading = false;
      });
    } else {
      setState(() {
        isBrandLoading = false;
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
    // Shuffle categories for random tab order
    final List<dynamic> shuffledCategories = List.from(categories);
    shuffledCategories.shuffle();
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'Store',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [cartCounterIcon(onPressed: () {}, iconColor: MyColors.black)],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in Store',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                if (value.isNotEmpty) {
                  searchBrands(value);
                } else {
                  setState(() {
                    brands = [];
                  });
                }
              },
            ),
          ),
          // Brand List if searching
          if (searchQuery.isNotEmpty)
            Expanded(
              child: isBrandLoading
                  ? const Center(child: CircularProgressIndicator())
                  : brands.isEmpty
                      ? const Center(child: Text('Brand does not exist'))
                      : ListView.builder(
                          itemCount: brands.length,
                          itemBuilder: (context, index) {
                            final brand = brands[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to the brand products page, pass brand id
                                  Get.to(() =>
                                      BrandProducts(brandId: brand['_id']));
                                },
                                child: BrandCard(
                                  showBorder: false,
                                  brandName: brand['name'] ?? '',
                                  brandImage: brand['logo'] ?? '',
                                  stock: brand['productCount'] ?? 0,
                                ),
                              ),
                            );
                          },
                        ),
            )
          else
            // Normal store content
            Expanded(
              child: DefaultTabController(
                length: shuffledCategories.length,
                child: NestedScrollView(
                  headerSliverBuilder: (_, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: true,
                        floating: true,
                        backgroundColor: HelperFunctions.isDarkMode(context)
                            ? MyColors.black
                            : MyColors.white,
                        expandedHeight: 440,
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.all(MySize.defaultSpace),
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              const SizedBox(height: MySize.spaceBtwItems),
                              const SizedBox(height: MySize.spaceBtwItems),
                              SectionHeading(
                                title: 'Featured Brands',
                                showActionButton: true,
                                onPressed: () =>
                                    Get.to(() => const AllBrandScreen()),
                              ),
                              const SizedBox(
                                  height: MySize.spaceBtwItems / 1.5),
                              const FeaturedBrandsSection(),
                            ],
                          ),
                        ),
                        bottom: MyTabBar(
                          tabs: shuffledCategories
                              .map<Widget>(
                                  (cat) => Tab(child: Text(cat['name'] ?? '')))
                              .toList(),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: shuffledCategories
                        .map<Widget>((cat) => CatagoryTab(category: cat))
                        .toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FeaturedBrandsSection extends StatefulWidget {
  const FeaturedBrandsSection({super.key});

  @override
  State<FeaturedBrandsSection> createState() => _FeaturedBrandsSectionState();
}

class _FeaturedBrandsSectionState extends State<FeaturedBrandsSection> {
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
    if (isLoading) return const Center(child: CircularProgressIndicator());
    return Gridlayout(
      itemCount: brands.length,
      mainAxisExtent: 80,
      itemBuilder: (context, index) {
        final brand = brands[index];
        return BrandCard(
          showBorder: false,
          brandName: brand.name ?? '',
          brandImage: brand.logo ?? '',
          stock: brand.productCount ?? 0,
        );
      },
    );
  }
}
