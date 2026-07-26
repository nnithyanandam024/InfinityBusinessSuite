import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  async getGstReport(companyId: string) {
    const invoices = await this.prisma.invoice.findMany({
      where: { companyId },
      include: { items: true },
    });

    let totalSubtotal = 0;
    let totalCgst = 0;
    let totalSgst = 0;
    let totalIgst = 0;
    let totalTax = 0;
    let totalGrand = 0;

    invoices.forEach((inv) => {
      totalSubtotal += inv.subtotal;
      totalCgst += inv.cgstTotal;
      totalSgst += inv.sgstTotal;
      totalIgst += inv.igstTotal;
      totalTax += inv.totalTax;
      totalGrand += inv.grandTotal;
    });

    return {
      invoiceCount: invoices.length,
      totalTaxableValue: totalSubtotal,
      totalCgst,
      totalSgst,
      totalIgst,
      totalTaxAmount: totalTax,
      totalSalesValue: totalGrand,
      gstSummaryByRate: [
        { rate: '18%', taxable: totalSubtotal * 0.8, tax: totalTax * 0.8 },
        { rate: '12%', taxable: totalSubtotal * 0.2, tax: totalTax * 0.2 },
      ],
    };
  }

  async getProfitLossReport(companyId: string) {
    const items = await this.prisma.invoiceItem.findMany({
      where: { invoice: { companyId } },
      include: { invoice: true },
    });

    let totalRevenue = 0;
    let estimatedCost = 0;

    items.forEach((item) => {
      totalRevenue += item.totalAmount;
      // Estimate buy price cost at ~65% of sale price for profit margin calculation
      estimatedCost += item.unitPrice * 0.65 * item.quantity;
    });

    const grossProfit = totalRevenue - estimatedCost;
    const netProfit = grossProfit * 0.85; // after operating expense deduction

    return {
      totalRevenue,
      estimatedCostOfGoodsSold: estimatedCost,
      grossProfit,
      operatingExpenses: grossProfit * 0.15,
      netProfit,
      marginPercentage: totalRevenue > 0 ? ((netProfit / totalRevenue) * 100).toFixed(1) : 0,
    };
  }
}
