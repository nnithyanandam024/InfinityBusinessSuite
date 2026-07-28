import { Controller, Get, Post, Body, Param, UseGuards, Req } from '@nestjs/common';
import { KhataService } from './khata.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('khata')
@UseGuards(JwtAuthGuard)
export class KhataController {
  constructor(private readonly khataService: KhataService) {}

  @Post('entry')
  async createEntry(@Req() req: any, @Body() body: { customerId: string; type: 'DEBIT' | 'CREDIT'; amount: number; referenceType?: string; referenceId?: string; note?: string }) {
    return this.khataService.createEntry(req.user.companyId, body);
  }

  @Get('customer/:id')
  async getCustomerLedger(@Req() req: any, @Param('id') customerId: string) {
    return this.khataService.getCustomerLedger(req.user.companyId, customerId);
  }
}
