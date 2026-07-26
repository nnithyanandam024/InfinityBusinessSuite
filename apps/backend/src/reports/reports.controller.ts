import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/reports')
export class ReportsController {
  constructor(private reportsService: ReportsService) {}

  @Get('gst')
  async getGstReport(@Request() req: any) {
    return this.reportsService.getGstReport(req.user.companyId);
  }

  @Get('profit-loss')
  async getProfitLoss(@Request() req: any) {
    return this.reportsService.getProfitLossReport(req.user.companyId);
  }
}
