import { Controller, Get, Put, Body, UseGuards, Request } from '@nestjs/common';
import { SettingsService } from './settings.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/settings')
export class SettingsController {
  constructor(private settingsService: SettingsService) {}

  @Get()
  async getSettings(@Request() req: any) {
    return this.settingsService.getCompanySettings(req.user.companyId);
  }

  @Put()
  async updateSettings(@Request() req: any, @Body() body: any) {
    return this.settingsService.updateCompanySettings(req.user.companyId, body);
  }

  @Get('export')
  async exportData(@Request() req: any) {
    return this.settingsService.exportCompanyData(req.user.companyId);
  }
}
