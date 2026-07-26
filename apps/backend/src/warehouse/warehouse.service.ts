import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WarehouseService {
  constructor(private prisma: PrismaService) {}

  async getWarehouses(companyId: string) {
    let warehouses = await this.prisma.warehouse.findMany({
      where: { companyId },
      orderBy: { name: 'asc' },
    });

    if (warehouses.length === 0) {
      // Seed default main warehouse
      await this.prisma.warehouse.createMany({
        data: [
          { companyId, name: 'Main Central Store', location: 'Chennai HQ', manager: 'Nithyanandam N' },
          { companyId, name: 'North Branch Depot', location: 'Industrial Area, Plot 14', manager: 'Rajesh Kumar' },
        ],
      });

      warehouses = await this.prisma.warehouse.findMany({
        where: { companyId },
        orderBy: { name: 'asc' },
      });
    }

    return warehouses;
  }

  async createWarehouse(companyId: string, dto: { name: string; location: string; manager?: string }) {
    return this.prisma.warehouse.create({
      data: {
        companyId,
        name: dto.name,
        location: dto.location,
        manager: dto.manager,
      },
    });
  }
}
