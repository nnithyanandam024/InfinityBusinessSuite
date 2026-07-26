import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { BillingService } from './billing.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/billing')
export class BillingController {
  constructor(private billingService: BillingService) {}

  @Get('invoices')
  async getInvoices(@Request() req: any) {
    return this.billingService.getInvoices(req.user.companyId);
  }

  @Get('invoices/:id')
  async getInvoiceById(@Request() req: any, @Param('id') id: string) {
    return this.billingService.getInvoiceById(req.user.companyId, id);
  }

  @Post('invoices')
  async createInvoice(@Request() req: any, @Body() body: any) {
    return this.billingService.createInvoice(req.user.companyId, body);
  }
}
