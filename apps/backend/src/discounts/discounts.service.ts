import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DiscountsService {
  constructor(private prisma: PrismaService) {}

  async getDiscounts(companyId: string) {
    let coupons = await this.prisma.discount.findMany({
      where: { companyId },
      orderBy: { createdAt: 'desc' },
    });

    if (coupons.length === 0) {
      // Seed default coupons
      await this.prisma.discount.createMany({
        data: [
          { companyId, code: 'WELCOME10', type: 'PERCENTAGE', value: 10, minSubtotal: 500, active: true },
          { companyId, code: 'FLAT200', type: 'FLAT', value: 200, minSubtotal: 1000, active: true },
        ],
      });

      coupons = await this.prisma.discount.findMany({
        where: { companyId },
        orderBy: { createdAt: 'desc' },
      });
    }

    return coupons;
  }

  async validateCoupon(companyId: string, code: string, subtotal: number) {
    const coupon = await this.prisma.discount.findFirst({
      where: { companyId, code: code.toUpperCase(), active: true },
    });

    if (!coupon) {
      throw new NotFoundException('Invalid or expired coupon code');
    }

    if (subtotal < coupon.minSubtotal) {
      throw new BadRequestException(`Minimum cart value of ₹${coupon.minSubtotal} required for this coupon`);
    }

    const discountAmount =
      coupon.type === 'PERCENTAGE'
        ? (subtotal * coupon.value) / 100
        : Math.min(coupon.value, subtotal);

    return {
      valid: true,
      code: coupon.code,
      type: coupon.type,
      value: coupon.value,
      discountAmount,
    };
  }

  async createDiscount(companyId: string, dto: {
    code: string;
    type?: 'PERCENTAGE' | 'FLAT';
    value: number;
    minSubtotal?: number;
  }) {
    return this.prisma.discount.create({
      data: {
        companyId,
        code: dto.code.toUpperCase(),
        type: dto.type || 'PERCENTAGE',
        value: Number(dto.value),
        minSubtotal: dto.minSubtotal ? Number(dto.minSubtotal) : 0,
        active: true,
      },
    });
  }
}
