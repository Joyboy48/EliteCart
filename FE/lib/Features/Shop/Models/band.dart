class Brand {
  final String id;
  final String name;
  final String logo;
  final int productCount; 

  Brand({
    required this.id,
    required this.name,
    required this.logo,
    required this.productCount, 
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'],
      name: json['name'],
      logo: json['logo'],
      productCount: json['productCount'] ?? 0, 
    );
  }
}