import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/primary_headerContainer.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/search_container.dart';
import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Features/Shop/Screens/All_product/all_product.dart';
import 'package:studio_projects/Features/Shop/Screens/home/widgets/homeAppbar.dart';
import 'package:studio_projects/Features/Shop/Screens/home/widgets/home_catagory.dart';
import 'package:studio_projects/Features/Shop/Screens/home/widgets/promo_slider.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Utiles/HTTP/http_client.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool isLoading = true;
  List products = [];
  List popularProducts = [];
  String searchQuery = '';
  List searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchProducts();
  }

  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');
      if (savedToken == null || savedToken.isEmpty) {
        setState(() {
          userName = null;
          isLoading = false;
        });
        return;
      }
      final response = await HttpHelper().getUserProfile(savedToken);
      if (response['statusCode'] == 200) {
        final user = response['body']['data']['user'];
        setState(() {
          userName = user['firstName'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          userName = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = null;
        isLoading = false;
      });
    }
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse(ApiConstants.baseUrl + "/products/products"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['data'] ?? [];
        // Pick 4 random products for popularProducts
        popularProducts = List.from(products);
        popularProducts.shuffle(Random());
        if (popularProducts.length > 4) {
          popularProducts = popularProducts.sublist(0, 4);
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> searchProducts(String query) async {
    setState(() {
      isSearching = true;
      searchQuery = query;
    });
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/products/products/search?q=$query'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = data['data'] ?? [];
        isSearching = false;
      });
    } else {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  //header ---------------
                  primaryHeaderContainer(
                    child: Column(
                      children: [
                        //appbar-----------------
                        homeAppbar(
                          userName: userName,
                        ),
                        const SizedBox(
                          height: MySize.spaceBtwSection,
                        ),
                        //search bar--------------------
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search in Store',
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 14),
                              ),
                              onChanged: searchProducts,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: MySize.spaceBtwSection,
                        ),
                        //catagorys----------------
                        const Padding(
                          padding: EdgeInsets.only(left: MySize.defaultSpace),
                          child: Column(
                            children: [
                              ///heading------
                              SectionHeading(
                                title: 'Popular Catagory',
                                showActionButton: false,
                                textColor: MyColors.white,
                              ),
                              SizedBox(
                                height: MySize.spaceBtwItems,
                              ),
                              //cetegory-----------
                              homeCatagory()
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: MySize.spaceBtwSection,
                        )
                      ],
                    ),
                  ),
                  //body--------------
                  if (searchQuery.isNotEmpty)
                    isSearching
                        ? const Center(child: CircularProgressIndicator())
                        : searchResults.isEmpty
                            ? const Center(child: Text('No products found'))
                            : Padding(
                                padding:
                                    const EdgeInsets.all(MySize.defaultSpace),
                                child: Gridlayout(
                                  itemCount: searchResults.length,
                                  itemBuilder: (_, index) =>
                                      ProductCardVertical(
                                          product: searchResults[index]),
                                ),
                              )
                  else
                    Padding(
                        padding: const EdgeInsets.all(MySize.defaultSpace),
                        child: Column(
                          children: [
                            const promoSlider(
                              banners: [
                                ImageStrings.banner1,
                                ImageStrings.banner2,
                                ImageStrings.banner3,
                                ImageStrings.banner4,
                                ImageStrings.banner5,
                                ImageStrings.banner6,
                                ImageStrings.banner7,
                                ImageStrings.banner8,
                                ImageStrings.banner9,
                              ],
                            ),
                            const SizedBox(
                              height: MySize.spaceBtwItems / 2,
                            ),
                            SectionHeading(
                              title: "Popular Products",
                              onPressed: () =>
                                  Get.to(() => const AllProductScreen()),
                            ),
                            const SizedBox(
                              height: MySize.spaceBtwItems,
                            ),
                            Gridlayout(
                              itemCount: popularProducts.length,
                              itemBuilder: (_, index) => ProductCardVertical(
                                  product: popularProducts[index]),
                            ),
                          ],
                        ))
                ],
              ),
            ),
    );
  }
}

// import 'package:studio_projects/Common/Widgets/custom_shapes/container/primary_headerContainer.dart';
// import 'package:studio_projects/Common/Widgets/custom_shapes/container/search_container.dart';
// import 'package:studio_projects/Common/Widgets/layouts/grid_layout.dart';
// import 'package:studio_projects/Common/Widgets/products/product_cards/product_card_vertical.dart';
// import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
// import 'package:studio_projects/Features/Shop/Screens/All_product/all_product.dart';
// import 'package:studio_projects/Features/Shop/Screens/home/widgets/homeAppbar.dart';
// import 'package:studio_projects/Features/Shop/Screens/home/widgets/home_catagory.dart';
// import 'package:studio_projects/Features/Shop/Screens/home/widgets/promo_slider.dart';
// import 'package:studio_projects/Utiles/constants/colors.dart';
// import 'package:studio_projects/Utiles/constants/image_strings.dart';
// import 'package:studio_projects/Utiles/constants/size.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../Utiles/HTTP/http_client.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? userName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//   }

//   Future<void> fetchUserProfile() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedToken = prefs.getString('token');
//       if (savedToken == null || savedToken.isEmpty) {
//         setState(() {
//           userName = null;
//           isLoading = false;
//         });
//         return;
//       }
//       final response = await HttpHelper().getUserProfile(savedToken);
//       if (response['statusCode'] == 200) {
//         final user = response['body']['data']['user'];
//         setState(() {
//           userName = user['firstName'] ?? '';
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           userName = null;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         userName = null;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   //header ---------------
//                   primaryHeaderContainer(
//                     child: Column(
//                       children: [
//                         //appbar-----------------
//                         homeAppbar(
//                           userName: userName,
//                         ),
//                         const SizedBox(
//                           height: MySize.spaceBtwSection,
//                         ),
//                         //search bar--------------------
//                         const searchContainer(
//                           text: 'Search in Store',
//                         ),
//                         const SizedBox(
//                           height: MySize.spaceBtwSection,
//                         ),
//                         //catagorys----------------
//                         const Padding(
//                           padding: EdgeInsets.only(left: MySize.defaultSpace),
//                           child: Column(
//                             children: [
//                               ///heading------
//                               SectionHeading(
//                                 title: 'Popular Catagory',
//                                 showActionButton: false,
//                                 textColor: MyColors.white,
//                               ),
//                               SizedBox(
//                                 height: MySize.spaceBtwItems,
//                               ),
//                               //cetegory-----------
//                               homeCatagory()
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: MySize.spaceBtwSection,
//                         )
//                       ],
//                     ),
//                   ),
//                   //body--------------
//                   Padding(
//                       padding: const EdgeInsets.all(MySize.defaultSpace),
//                       child: Column(
//                         children: [
//                           const promoSlider(
//                             banners: [
//                               ImageStrings.banner1,
//                               ImageStrings.banner2,
//                               ImageStrings.banner3,
//                               ImageStrings.banner4,
//                               ImageStrings.banner5,
//                               ImageStrings.banner6,
//                               ImageStrings.banner7,
//                               ImageStrings.banner8,
//                               ImageStrings.banner9,
//                             ],
//                           ),
//                           const SizedBox(
//                             height: MySize.spaceBtwItems / 2,
//                           ),
//                           SectionHeading(
//                             title: "Popular Products",
//                             onPressed: () =>
//                                 Get.to(() => const AllProductScreen()),
//                           ),
//                           const SizedBox(
//                             height: MySize.spaceBtwItems,
//                           ),
//                           Gridlayout(
//                             itemCount: 4,
//                             itemBuilder: (_, int) =>
//                                 const ProductCardVertical(),
//                           ),
//                         ],
//                       ))
//                 ],
//               ),
//             ),
//     );
//   }
// }
