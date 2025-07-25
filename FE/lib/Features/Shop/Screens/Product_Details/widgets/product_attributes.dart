import 'package:studio_projects/Common/Widgets/chips/choice_chip.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/rounded_container.dart';
import 'package:studio_projects/Common/Widgets/texts/product_price_text.dart';
import 'package:studio_projects/Common/Widgets/texts/product_title_text.dart';
import 'package:studio_projects/Common/Widgets/texts/section_heading.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class ProductAttributes extends StatelessWidget {
  final dynamic product;
  const ProductAttributes({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colors = (product['colors'] is List)
        ? product['colors']
        : (product['colors'] is Map)
            ? (product['colors'] as Map).values.toList()
            : [];
    final sizes = (product['sizes'] is List)
        ? product['sizes']
        : (product['sizes'] is Map)
            ? (product['sizes'] as Map).values.toList()
            : [];
    return Column(
      children: [
        ///Selecting Attributes and Description
        // RoundedContainer(
        //   padding: const EdgeInsets.all(MySize.md),
        //   backgroundColor: dark ? MyColors.darkerGrey : MyColors.grey,
        //   child: Column(
        //     children: [
        //       ///Title price stock status
        //       Row(
        //         children: [
        //           const SectionHeading(
        //             title: 'Variation',
        //             showActionButton: false,
        //           ),
        //           const SizedBox(
        //             width: MySize.spaceBtwItems,
        //           ),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Row(
        //                 children: [
        //                   const ProductTitleText(
        //                     title: 'Price : ',
        //                     //smallSize: true,
        //                   ),
        //                   const SizedBox(
        //                     width: MySize.spaceBtwItems,
        //                   ),
        //
        //                   ///Actual price
        //                   Text(
        //                     '₹3000',
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleLarge!
        //                         .apply(decoration: TextDecoration.lineThrough),
        //                   ),
        //                   const SizedBox(
        //                     width: MySize.spaceBtwItems,
        //                   ),
        //
        //                   ///sale price
        //                   const productPriceText(
        //                     price: '2250',
        //                   )
        //                 ],
        //               ),
        //               Row(
        //                 children: [
        //                   const ProductTitleText(
        //                     title: 'Stock : ',
        //                     //smallSize: true,
        //                   ),
        //                   Text(
        //                     ' In Stock',
        //                     style: Theme.of(context).textTheme.titleMedium,
        //                   )
        //                 ],
        //               )
        //             ],
        //           ),
        //         ],
        //       ),
        //
        //       ///Variation Description
        //       const ProductTitleText(
        //         title:
        //             'This is the Description of the productd and it can be maxed upto 4 line',
        //         smallSize: true,
        //         maxLines: 4,
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(
          height: MySize.spaceBtwItems,
        ),

        ///Attributes - Colors
        if (colors.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(title: 'Colors', showActionButton: false),
              const SizedBox(height: MySize.spaceBtwItems / 2),
              Wrap(
                spacing: 8,
                children: [
                  for (var i = 0; i < colors.length; i++)
                    MyChoiceChip(
                      text: colors[i].toString(),
                      selected: i == 0,
                      onSelected: (value) {},
                    ),
                ],
              ),
            ],
          ),

        ///Attributes - Sizes
        if (sizes.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(title: 'Size', showActionButton: false),
              const SizedBox(height: MySize.spaceBtwItems / 2),
              Wrap(
                spacing: 8,
                children: [
                  for (var i = 0; i < sizes.length; i++)
                    MyChoiceChip(
                      text: sizes[i].toString(),
                      selected: i == 0,
                      onSelected: (value) {},
                    ),
                ],
              ),
            ],
          ),
        if (colors.isEmpty && sizes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No attributes available'),
          ),
      ],
    );
  }
}
