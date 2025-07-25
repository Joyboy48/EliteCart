import 'package:studio_projects/Common/Widgets/custom_shapes/container/rounded_container.dart';
import 'package:studio_projects/Common/Widgets/products/rating/rating_bar_indicator.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final double rating;
  final String date;
  final String comment;
  final bool showDelete;
  final VoidCallback? onDelete;
  const UserReviewCard({
    super.key,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.date,
    required this.comment,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? MyColors.darkerGrey : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  userAvatar != null
                      ? CircleAvatar(backgroundImage: NetworkImage(userAvatar!))
                      : const CircleAvatar(
                          backgroundImage: AssetImage(ImageStrings.userImage1)),
                  const SizedBox(width: MySize.spaceBtwItems),
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              if (showDelete && onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                )
              else
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              MyRatingBarIndicator(rating: rating),
              const SizedBox(width: 8),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          const SizedBox(height: 12),
          // Review text, left-aligned
          Align(
            alignment: Alignment.centerLeft,
            child: ReadMoreText(
              comment,
              trimLines: 3,
              trimExpandedText: 'Show less',
              trimCollapsedText: 'Show more',
              trimMode: TrimMode.Line,
              moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary),
              lessStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewSubmitForm extends StatefulWidget {
  final void Function(double rating, String comment) onSubmit;
  const ReviewSubmitForm({super.key, required this.onSubmit});

  @override
  State<ReviewSubmitForm> createState() => _ReviewSubmitFormState();
}

class _ReviewSubmitFormState extends State<ReviewSubmitForm> {
  double rating = 5.0;
  final TextEditingController _controller = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text('Your Rating', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            for (int i = 1; i <= 5; i++)
              IconButton(
                icon: Icon(
                  i <= rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    rating = i.toDouble();
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Your review',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting
                ? null
                : () {
                    setState(() {
                      isSubmitting = true;
                    });
                    widget.onSubmit(rating, _controller.text.trim());
                    setState(() {
                      isSubmitting = false;
                    });
                    _controller.clear();
                    rating = 5.0;
                  },
            child: isSubmitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Submit Review'),
          ),
        ),
      ],
    );
  }
}
