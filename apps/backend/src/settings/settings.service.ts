import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SettingsService {
  constructor(private prisma: PrismaService) {}

  async getCompanySettings(companyId: string) {
    const company = await this.prisma.company.findUnique({
      where: { id: companyId },
    });
    if (!company) throw new NotFoundException('Company not found');
    return company;
  }

  async updateCompanySettings(companyId: string, dto: {
    name?: string;
    phone?: string;
    gstin?: string;
    address?: string;
    city?: string;
    state?: string;
    pincode?: string;
    bankName?: string;
    bankAccountNo?: string;
    bankIfsc?: string;
    invoiceNotes?: string;
  }) {
    return this.prisma.company.update({
      where: { id: companyId },
      data: dto,
    });
  }

  async exportCompanyData(companyId: string) {
    const [invoices, products, customers, expenses] = await Promise.all([
      this.prisma.invoice.findMany({ where: { companyId }, include: { items: true } }),
      this.prisma.product.findMany({ where: { companyId } }),
      this.prisma.customer.findMany({ where: { companyId } }),
      this.prisma.expense.findMany({ where: { companyId } }),
    ]);

    return {
      exportedAt: new Date().toISOString(),
      invoicesCount: invoices.length,
      productsCount: products.length,
      customersCount: customers.length,
      expensesCount: expenses.length,
      invoices,
      products,
      customers,
      expenses,
    };
  }
}
