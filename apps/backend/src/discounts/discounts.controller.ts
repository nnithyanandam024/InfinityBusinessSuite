import { Controller, Get, Post, Body, Query, UseGuards, Request } from '@nestjs/common';
import { DiscountsService } from './discounts.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/discounts')
export class DiscountsController {
  constructor(private discountsService: DiscountsService) {}

  @Get()
  async getDiscounts(@Request() req: any) {
    return this.discountsService.getDiscounts(req.user.companyId);
  }

  @Post('validate')
  async validateCoupon(@Request() req: any, @Body() body: { code: string; subtotal: number }) {
    return this.discountsService.validateCoupon(req.user.companyId, body.code, body.subtotal);
  }

  @Post()
  async createDiscount(@Request() req: any, @Body() body: any) {
    return this.discountsService.createDiscount(req.user.companyId, body);
  }
}
