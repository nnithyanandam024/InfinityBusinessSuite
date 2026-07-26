import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductService {
  constructor(private prisma: PrismaService) {}

  async getCategories(companyId: string) {
    return this.prisma.category.findMany({
      where: { companyId },
      include: { _count: { select: { products: true } } },
      orderBy: { name: 'asc' },
    });
  }

  async createCategory(companyId: string, dto: { name: string; description?: string }) {
    return this.prisma.category.create({
      data: { companyId, name: dto.name, description: dto.description },
    });
  }

  async getProducts(companyId: string, search?: string) {
    const where: any = { companyId };
    if (search) {
      where.OR = [
        { name: { contains: search } },
        { sku: { contains: search } },
        { barcode: { contains: search } },
        { hsnCode: { contains: search } },
      ];
    }

    return this.prisma.product.findMany({
      where,
      include: { category: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getProductByBarcode(companyId: string, barcode: string) {
    const product = await this.prisma.product.findFirst({
      where: { companyId, barcode },
      include: { category: true },
    });
    if (!product) throw new NotFoundException('Product not found for barcode: ' + barcode);
    return product;
  }

  async createProduct(companyId: string, dto: {
    name: string;
    sku: string;
    barcode?: string;
    hsnCode?: string;
    categoryId?: string;
    buyPrice: number;
    sellPrice: number;
    gstRate?: number;
    currentStock: number;
    minStockAlert?: number;
    unit?: string;
  }) {
    return this.prisma.product.create({
      data: {
        companyId,
        name: dto.name,
        sku: dto.sku || `SKU-${Date.now().toString().slice(-6)}`,
        barcode: dto.barcode,
        hsnCode: dto.hsnCode || '8517',
        categoryId: dto.categoryId,
        buyPrice: Number(dto.buyPrice),
        sellPrice: Number(dto.sellPrice),
        gstRate: dto.gstRate !== undefined ? Number(dto.gstRate) : 18.0,
        currentStock: Number(dto.currentStock),
        minStockAlert: dto.minStockAlert !== undefined ? Number(dto.minStockAlert) : 10,
        unit: dto.unit || 'Pcs',
      },
      include: { category: true },
    });
  }

  async updateStock(companyId: string, productId: string, delta: number) {
    const product = await this.prisma.product.findFirst({
      where: { id: productId, companyId },
    });
    if (!product) throw new NotFoundException('Product not found');

    const newStock = Math.max(0, product.currentStock + delta);
    return this.prisma.product.update({
      where: { id: productId },
      data: { currentStock: newStock },
    });
  }

  async deleteProduct(companyId: string, productId: string) {
    return this.prisma.product.deleteMany({
      where: { id: productId, companyId },
    });
  }
}
