import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BillingService {
  constructor(private prisma: PrismaService) {}

  async getInvoices(companyId: string) {
    return this.prisma.invoice.findMany({
      where: { companyId },
      include: { items: true, customer: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getInvoiceById(companyId: string, invoiceId: string) {
    const invoice = await this.prisma.invoice.findFirst({
      where: { id: invoiceId, companyId },
      include: { items: true, customer: true, company: true },
    });
    if (!invoice) throw new NotFoundException('Invoice not found');
    return invoice;
  }

  async createInvoice(companyId: string, dto: {
    customerId?: string;
    customerName: string;
    customerPhone?: string;
    customerGstin?: string;
    gstType: 'INTRA_STATE' | 'INTER_STATE';
    paymentMethod?: string; // CASH, UPI, CARD, NETBANKING
    items: Array<{
      productId: string;
      quantity: number;
      discount?: number;
    }>;
  }) {
    if (!dto.items || dto.items.length === 0) {
      throw new BadRequestException('Invoice must contain at least one line item');
    }

    // Generate Invoice Number (e.g. INV-2026-1001)
    const count = await this.prisma.invoice.count({ where: { companyId } });
    const invoiceNumber = `INV-${new Date().getFullYear()}-${(count + 1001).toString()}`;

    let subtotal = 0;
    let totalDiscount = 0;
    let totalTax = 0;
    let cgstTotal = 0;
    let sgstTotal = 0;
    let igstTotal = 0;

    const preparedItems = [];

    for (const itemDto of dto.items) {
      const product = await this.prisma.product.findFirst({
        where: { id: itemDto.productId, companyId },
      });

      if (!product) {
        throw new BadRequestException(`Product ID ${itemDto.productId} not found`);
      }

      if (product.currentStock < itemDto.quantity) {
        throw new BadRequestException(
          `Insufficient stock for "${product.name}". Available: ${product.currentStock}, Requested: ${itemDto.quantity}`
        );
      }

      const qty = itemDto.quantity;
      const price = product.sellPrice;
      const itemDisc = itemDto.discount || 0;
      const lineSubtotal = price * qty - itemDisc;

      const gstRate = product.gstRate || 18.0;

      let lineCgst = 0;
      let lineSgst = 0;
      let lineIgst = 0;
      let lineTax = 0;

      if (dto.gstType === 'INTRA_STATE') {
        const halfRate = gstRate / 2;
        lineCgst = (lineSubtotal * halfRate) / 100;
        lineSgst = (lineSubtotal * halfRate) / 100;
        lineTax = lineCgst + lineSgst;
      } else {
        lineIgst = (lineSubtotal * gstRate) / 100;
        lineTax = lineIgst;
      }

      const lineTotal = lineSubtotal + lineTax;

      subtotal += price * qty;
      totalDiscount += itemDisc;
      totalTax += lineTax;
      cgstTotal += lineCgst;
      sgstTotal += lineSgst;
      igstTotal += lineIgst;

      preparedItems.push({
        productId: product.id,
        productName: product.name,
        hsnCode: product.hsnCode,
        quantity: qty,
        unitPrice: price,
        discount: itemDisc,
        gstRate,
        taxableAmount: lineSubtotal,
        cgstAmount: lineCgst,
        sgstAmount: lineSgst,
        igstAmount: lineIgst,
        totalAmount: lineTotal,
      });

      // Deduct stock from Inventory
      await this.prisma.product.update({
        where: { id: product.id },
        data: { currentStock: product.currentStock - qty },
      });
    }

    const grandTotal = Math.round(subtotal - totalDiscount + totalTax);

    const invoice = await this.prisma.invoice.create({
      data: {
        companyId,
        invoiceNumber,
        customerId: dto.customerId,
        customerName: dto.customerName || 'Walk-in Customer',
        customerPhone: dto.customerPhone,
        customerGstin: dto.customerGstin,
        gstType: dto.gstType || 'INTRA_STATE',
        subtotal,
        totalDiscount,
        totalTax,
        cgstTotal,
        sgstTotal,
        igstTotal,
        grandTotal,
        status: 'PAID',
        paymentMethod: dto.paymentMethod || 'CASH',
        items: {
          create: preparedItems,
        },
      },
      include: { items: true },
    });

    return invoice;
  }
}
