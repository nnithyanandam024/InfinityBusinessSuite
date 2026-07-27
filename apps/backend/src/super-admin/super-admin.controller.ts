import { Controller, Get, Put, Body, Param, UseGuards } from '@nestjs/common';
import { SuperAdminService } from './super-admin.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/super-admin')
export class SuperAdminController {
  constructor(private superAdminService: SuperAdminService) {}

  @Get('metrics')
  async getMetrics() {
    return this.superAdminService.getSuperAdminMetrics();
  }

  @Get('tenants')
  async getTenants() {
    return this.superAdminService.getTenants();
  }

  @Put('tenants/:id/status')
  async updateStatus(@Param('id') id: string, @Body() body: { status: string }) {
    return this.superAdminService.updateTenantStatus(id, body.status);
  }

  @Put('tenants/:id/extend-trial')
  async extendTrial(@Param('id') id: string, @Body() body: { days: number }) {
    return this.superAdminService.extendTenantTrial(id, body.days || 14);
  }
}
