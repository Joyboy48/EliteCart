import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/products/rating/rating_bar_indicator.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Review/widgets/rating_progress_indicator.dart';
import 'package:studio_projects/Features/Shop/Screens/Product_Review/widgets/review_detail_container.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/local_storage/storage_utility.dart';
import 'package:studio_projects/Utiles/constants/api_constants.dart';

class ProductReview extends StatefulWidget {
  final String productId;
  const ProductReview({super.key, required this.productId});

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  List reviews = [];
  bool isLoading = true;
  double avgRating = 0.0;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    loadUserIdAndFetchReviews();
  }

  Future<void> loadUserIdAndFetchReviews() async {
    currentUserId = await LocalStorage().getUserId();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}/reviews/product/${widget.productId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fetchedReviews = data['data'] ?? [];
      double sum = 0;
      for (var r in fetchedReviews) {
        sum += (r['rating'] ?? 0).toDouble();
      }
      setState(() {
        reviews = fetchedReviews;
        avgRating =
            fetchedReviews.isNotEmpty ? sum / fetchedReviews.length : 0.0;
        isLoading = false;
      });
    } else {
      setState(() {
        reviews = [];
        avgRating = 0.0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Appbar
      appBar: const MyAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrow: true,
      ),

      ///Body
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(MySize.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        "Ratings and  Reviews are Verifier and are from people who use the same type of device that you use."),
                    const SizedBox(
                      height: MySize.spaceBtwItems,
                    ),

                    ///overall product rating
                    Row(
                      children: [
                        Text(avgRating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(width: 8),
                        MyRatingBarIndicator(rating: avgRating),
                        const SizedBox(width: 8),
                        Text('(${reviews.length})',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(
                      height: MySize.spaceBtwItems,
                    ),

                    ///User review list
                    if (reviews.isEmpty)
                      const Text('No reviews yet.')
                    else
                      ...reviews.map((r) => UserReviewCard(
                            userName: r['userId']?['firstName'] ?? 'User',
                            userAvatar: null, // Add avatar if available
                            rating: (r['rating'] ?? 0).toDouble(),
                            date: r['date'] != null
                                ? r['date'].toString().substring(0, 10)
                                : '',
                            comment: r['comment'] ?? '',
                            showDelete: currentUserId != null &&
                                r['userId']?['_id'] == currentUserId,
                            onDelete: () async {
                              final token = await LocalStorage().getToken();
                              if (token == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You must be logged in to delete a review.')),
                                );
                                return;
                              }
                              final response = await http.delete(
                                Uri.parse(
                                    '${ApiConstants.baseUrl}/reviews/${r['_id']}'),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              );
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Review deleted.')),
                                );
                                fetchReviews();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to delete review: ${response.body}')),
                                );
                              }
                            },
                          )),
                    const SizedBox(height: 24),
                    ReviewSubmitForm(
                      onSubmit: (double rating, String comment) async {
                        if (comment.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter a review comment.')),
                          );
                          return;
                        }
                        final token = await LocalStorage().getToken();
                        if (token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'You must be logged in to submit a review.')),
                          );
                          return;
                        }
                        try {
                          print('Submitting review with token: ' +
                              (token ?? 'NO TOKEN'));
                          print('Review body: ' +
                              json.encode({
                                'productId': widget.productId,
                                'rating': rating,
                                'comment': comment,
                              }));
                          final response = await http.post(
                            Uri.parse('${ApiConstants.baseUrl}/reviews/'),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token',
                            },
                            body: json.encode({
                              'productId': widget.productId,
                              'rating': rating,
                              'comment': comment,
                            }),
                          );
                          print(
                              'Review POST response: ${response.statusCode} ${response.body}');
                          if (response.statusCode == 201) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Review submitted!')),
                            );
                            fetchReviews();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to submit review: \n${response.body}')),
                            );
                          }
                        } catch (e) {
                          print('Review submission error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
