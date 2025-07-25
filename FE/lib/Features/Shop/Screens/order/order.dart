import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Features/Shop/Screens/order/widget/order_list.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: Text('Orders',style: Theme.of(context).textTheme.headlineSmall,),
        showBackArrow: true,),
      body: const Padding(padding: EdgeInsets.all(MySize.defaultSpace),
        child: OrderListItems(),),
    );
  }
}