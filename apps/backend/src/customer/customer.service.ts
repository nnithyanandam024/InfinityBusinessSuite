import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CustomerService {
  constructor(private prisma: PrismaService) {}

  async getCustomers(companyId: string) {
    return this.prisma.customer.findMany({
      where: { companyId },
      orderBy: { name: 'asc' },
    });
  }

  async createCustomer(companyId: string, dto: {
    name: string;
    email?: string;
    phone: string;
    gstin?: string;
    address?: string;
    openingBalance?: number;
  }) {
    return this.prisma.customer.create({
      data: {
        companyId,
        name: dto.name,
        email: dto.email,
        phone: dto.phone,
        gstin: dto.gstin,
        address: dto.address,
        balance: dto.openingBalance ? Number(dto.openingBalance) : 0.0,
      },
    });
  }

  async getSuppliers(companyId: string) {
    return this.prisma.supplier.findMany({
      where: { companyId },
      orderBy: { name: 'asc' },
    });
  }

  async createSupplier(companyId: string, dto: {
    name: string;
    email?: string;
    phone: string;
    gstin?: string;
    address?: string;
    openingBalance?: number;
  }) {
    return this.prisma.supplier.create({
      data: {
        companyId,
        name: dto.name,
        email: dto.email,
        phone: dto.phone,
        gstin: dto.gstin,
        address: dto.address,
        balance: dto.openingBalance ? Number(dto.openingBalance) : 0.0,
      },
    });
  }
}
