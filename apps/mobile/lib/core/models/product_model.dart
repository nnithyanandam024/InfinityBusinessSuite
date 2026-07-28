class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String? barcode;
  final double buyPrice;
  final double sellPrice;
  final double gstRate;
  final int currentStock;
  final String unit;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    this.barcode,
    required this.buyPrice,
    required this.sellPrice,
    this.gstRate = 18.0,
    required this.currentStock,
    this.unit = 'Pcs',
  });
}
