import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AiService {
  constructor(private prisma: PrismaService) {}

  async getSalesForecast(companyId: string) {
    const products = await this.prisma.product.findMany({
      where: { companyId },
    });

    const invoiceItems = await this.prisma.invoiceItem.findMany({
      where: { invoice: { companyId } },
    });

    // Calculate total quantity sold per product
    const salesMap: Record<string, number> = {};
    invoiceItems.forEach((item) => {
      salesMap[item.productId] = (salesMap[item.productId] || 0) + item.quantity;
    });

    const recommendations = products.map((product) => {
      const soldQty = salesMap[product.id] || 0;
      // Daily sales velocity calculation (assume 30 day window)
      const dailyVelocity = soldQty > 0 ? soldQty / 30 : 0.2;
      const daysOfStockLeft = Math.round(product.currentStock / (dailyVelocity || 0.1));

      // AI recommendation formula
      const recommendedReorderQty =
        product.currentStock <= product.minStockAlert
          ? Math.max(50, product.minStockAlert * 3 - product.currentStock)
          : 0;

      const priority =
        daysOfStockLeft <= 5 ? 'HIGH' : daysOfStockLeft <= 15 ? 'MEDIUM' : 'LOW';

      return {
        productId: product.id,
        productName: product.name,
        currentStock: product.currentStock,
        minStockAlert: product.minStockAlert,
        unit: product.unit,
        totalSold: soldQty,
        estimatedDaysLeft: daysOfStockLeft,
        recommendedReorderQty,
        priority,
      };
    });

    return {
      generatedAt: new Date().toISOString(),
      highPriorityReordersCount: recommendations.filter((r) => r.priority === 'HIGH').length,
      recommendations,
    };
  }
}
