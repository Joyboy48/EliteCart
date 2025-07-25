import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:studio_projects/Common/Widgets/image_text_widget/verticalImageText.dart';
import 'package:studio_projects/Features/Shop/Screens/sub_category/sub_categories.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';
class homeCatagory extends StatefulWidget {
  const homeCatagory({super.key});

  @override
  State<homeCatagory> createState() => _homeCatagoryState();
}

class _homeCatagoryState extends State<homeCatagory> {
  List<dynamic> categories = [];
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final category = categories[index];
          return verticalImageText(
            image: category['icon']?.toString() ?? 'assets/images/default.png',
            title: category['name'] ?? '', // fetched from backend
            onTap: () => Get.to(() => SubCategoriesScreen(category: category)),
          );
        },
      ),
    );
  }
}
