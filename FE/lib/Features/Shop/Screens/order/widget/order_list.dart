import 'package:flutter/material.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/container/rounded_container.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/local_storage/storage_utility.dart';
import 'package:intl/intl.dart';
import 'package:studio_projects/Features/Shop/Screens/order/widget/order_detail_screen.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class OrderListItems extends StatefulWidget {
  const OrderListItems({super.key});

  @override
  State<OrderListItems> createState() => _OrderListItemsState();
}

class _OrderListItemsState extends State<OrderListItems> {
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    final token = await LocalStorage().getToken();
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          orders = (data['data'] ?? [])
              .where((order) => order['status'] != 'Cancelled')
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found.'));
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (_, index) =>
          const SizedBox(height: MySize.spaceBtwItems),
      itemBuilder: (_, index) {
        final order = orders[index];
        final status = order['status'] ?? 'Pending';
        final orderDate = order['orderDate'] != null
            ? DateFormat('dd MMM, yyyy')
                .format(DateTime.parse(order['orderDate']))
            : '';
        final shippingDate = order['shippingDate'] != null
            ? DateFormat('dd MMM, yyyy')
                .format(DateTime.parse(order['shippingDate']))
            : '';
        final orderId = order['_id']?.toString() ?? '';
        final total = order['totalAmount'] ?? 0;
        return RoundedContainer(
          padding: const EdgeInsets.all(MySize.md),
          showBorder: true,
          backgroundColor: dark ? MyColors.dark : MyColors.light,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_shipping),
                  const SizedBox(width: MySize.spaceBtwItems / 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(status,
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: MyColors.primary, fontWeightDelta: 1)),
                        Text(orderDate,
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                            order: order,
                            onOrderCancelled: () {
                              setState(() {
                                orders.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_right, size: MySize.iconSm),
                  ),
                ],
              ),
              const SizedBox(height: MySize.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_number),
                        const SizedBox(width: MySize.spaceBtwItems / 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text('#$orderId',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: MySize.spaceBtwItems / 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Shipping Date',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text(shippingDate,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MySize.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Total: ₹$total',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
