import 'package:studio_projects/Common/Widgets/custom_shapes/container/circular_container.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:flutter/material.dart';

class MyChoiceChip extends StatelessWidget {
  const MyChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = HelperFunctions.getColor(text) != null;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: isColor? const SizedBox() :Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? MyColors.white : null),
        avatar: isColor?
        CircularContainer(width: 50,height: 50,
            backgroundColor:HelperFunctions.getColor(text)!): null,
        shape:isColor? const CircleBorder():null,
        backgroundColor: isColor ? Colors.green:null,
        labelPadding:isColor ? const EdgeInsets.all(0):null,
        padding: isColor ? const EdgeInsets.all(0):null,

      ),
    );
  }
}