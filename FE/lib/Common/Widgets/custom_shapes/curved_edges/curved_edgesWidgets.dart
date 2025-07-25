import 'package:studio_projects/Common/Widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:flutter/cupertino.dart';

class CurvedEdgeWidget extends StatelessWidget {
  const CurvedEdgeWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: CustomCurvedEdges(), child: child);
  }
}

