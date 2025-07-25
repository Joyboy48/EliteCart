class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discount;
  final String brandId;
  final List<String> images;
  final List<String> categories;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.brandId,
    required this.images,
    required this.categories,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      brandId: json['brandId'],
      images: List<String>.from(json['images']),
      categories: List<String>.from(json['categories']),
      stock: json['stock'],
    );
  }
}