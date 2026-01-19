class Product {
  String id;
  String name;
  String category;
  int stock;
  int minStock;
  double price;
  String? barcode;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.minStock,
    required this.price,
    this.barcode,
  });
}