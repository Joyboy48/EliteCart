import 'package:studio_projects/Common/Widgets/custom_shapes/container/circular_container.dart';
import 'package:studio_projects/Common/Widgets/custom_shapes/curved_edges/curved_edgesWidgets.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:flutter/cupertino.dart';

// class primaryHeaderContainer extends StatelessWidget {
//   const primaryHeaderContainer({
//     super.key, required this.child,
//   });
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return CurvedEdgeWidget(
//       child: Container(
//         color: MyColors.primary,
//         padding: EdgeInsets.all(0),
//         child: SizedBox(
//           height: 400,
//           child: Stack(
//             children: [
//               Positioned(
//                   top: -150,
//                   right: -250,
//                   child: CircularContainer(
//                     backgroundColor:
//                     MyColors.textWhite.withOpacity(0.1),
//                   )),
//               Positioned(
//                   top: 100,
//                   right: -300,
//                   child: CircularContainer(
//                     backgroundColor:
//                     MyColors.textWhite.withOpacity(0.1),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class primaryHeaderContainer extends StatelessWidget {
  const primaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgeWidget(
      child: Container(
        color: MyColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            child,
            Positioned(
              top: -150,
              right: -250,
              child: CircularContainer(
                backgroundColor: MyColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: CircularContainer(
                backgroundColor: MyColors.textWhite.withOpacity(0.1),
              ),),
             // Add the child widget here
          ],
        ),
      ),
    );
  }
}


