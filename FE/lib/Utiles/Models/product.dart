class Product {
  final String? imageUrl;
  final String? title;
  final String? brand;
  final num? price;
  final num? discount;
  final bool isWishlisted; // <-- Added

  Product({
    this.imageUrl,
    this.title,
    this.brand,
    this.price,
    this.discount,
    this.isWishlisted = false, // <-- Added default
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        imageUrl: json['imageUrl'],
        title: json['title'],
        brand: json['brand'],
        price: json['price'],
        discount: json['discount'],
        isWishlisted: json['isWishlisted'] ?? false, // <-- Added
      );
}
