// import 'package:studio_projects/Common/Widgets/custom_shapes/container/rounded_container.dart';
// import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
// import 'package:studio_projects/Utiles/constants/colors.dart';
// import 'package:studio_projects/Utiles/constants/size.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// class SingleAddress extends StatelessWidget {
//   final Map<String, dynamic> address;
//   final bool selectedAddress;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//
//   const SingleAddress({
//     super.key,
//     required this.address,
//     this.selectedAddress = false,
//     this.onEdit,
//     this.onDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(address['name'] ?? ''),
//         subtitle: Text(
//           "${address['street']}, ${address['city']}, ${address['state']}, ${address['postalCode']}, ${address['country']}",
//         ),
//         trailing: PopupMenuButton<String>(
//           onSelected: (value) {
//             if (value == 'edit' && onEdit != null) {
//               onEdit!();
//             } else if (value == 'delete' && onDelete != null) {
//               onDelete!();
//             }
//           },
//           itemBuilder: (context) => [
//             const PopupMenuItem(value: 'edit', child: Text("Edit")),
//             const PopupMenuItem(value: 'delete', child: Text("Delete")),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';

class SingleAddress extends StatelessWidget {
  final Map<String, dynamic> address;
  final bool selectedAddress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SingleAddress({
    super.key,
    required this.address,
    this.selectedAddress = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MySize.md),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: selectedAddress ? MyColors.primary.withOpacity(0.08) : Colors.white,
        border: Border.all(
          color: selectedAddress ? MyColors.primary : Colors.grey.shade300,
          width: selectedAddress ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and phone
          Row(
            children: [
              Icon(Iconsax.user, color: MyColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                address['name'] ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Icon(Iconsax.call, color: Colors.grey.shade600, size: 18),
              const SizedBox(width: 4),
              Text(
                address['phoneNumber'] ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Street
          Row(
            children: [
              Icon(Iconsax.location, color: Colors.blueGrey, size: 18),
              const SizedBox(width: 8),
              Text(
                "Street: ",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
              Expanded(
                child: Text(
                  address['street'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Postal Code
          Row(
            children: [
              Icon(Iconsax.code, color: Colors.orange, size: 18),
              const SizedBox(width: 8),
              Text(
                "Postal Code: ",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
              Text(
                address['postalCode'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // City
          Row(
            children: [
              Icon(Iconsax.building, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Text(
                "City: ",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
              Text(
                address['city'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // State
          Row(
            children: [
              Icon(Iconsax.map, color: Colors.purple, size: 18),
              const SizedBox(width: 8),
              Text(
                "State: ",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
              Text(
                address['state'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Country
          Row(
            children: [
              Icon(Iconsax.global, color: Colors.teal, size: 18),
              const SizedBox(width: 8),
              Text(
                "Country: ",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
              Text(
                address['country'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (selectedAddress)
                Chip(
                  label: const Text('Selected'),
                  backgroundColor: MyColors.primary.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: MyColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                  const PopupMenuItem(value: 'delete', child: Text("Delete")),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ],
      ),
    );
  }
}