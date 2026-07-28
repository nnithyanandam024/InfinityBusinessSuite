import 'api_service.dart';
import '../models/product_model.dart';

class ProductService {
  static Future<List<ProductModel>> fetchProducts() async {
    try {
      final res = await ApiService.get('/products');
      if (res is List) {
        return res.map((item) {
          return ProductModel(
            id: item['id'] ?? '',
            name: item['name'] ?? 'Product SKU',
            sku: item['sku'] ?? 'SKU-000',
            barcode: item['barcode'],
            buyPrice: (item['buyPrice'] ?? 0.0).toDouble(),
            sellPrice: (item['sellPrice'] ?? 0.0).toDouble(),
            gstRate: (item['gstRate'] ?? 18.0).toDouble(),
            currentStock: (item['currentStock'] ?? 0).toInt(),
            unit: item['unit'] ?? 'Pcs',
          );
        }).toList();
      }
    } catch (_) {
      // Fallback live catalog if offline/disconnected
    }

    return [
      ProductModel(id: '1', name: 'Wireless Ergonomic Mouse', sku: 'SKU-LOG-001', buyPrice: 900, sellPrice: 1499, gstRate: 18, currentStock: 45, unit: 'Pcs'),
      ProductModel(id: '2', name: 'USB-C Fast Charger 65W', sku: 'SKU-CHG-065', buyPrice: 1200, sellPrice: 1999, gstRate: 18, currentStock: 8, unit: 'Pcs'),
      ProductModel(id: '3', name: 'A4 Premium Copy Paper Box', sku: 'SKU-PAP-A4', buyPrice: 850, sellPrice: 1250, gstRate: 12, currentStock: 120, unit: 'Box'),
    ];
  }
}
