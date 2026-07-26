import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { AuditService } from './audit.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/audit')
export class AuditController {
  constructor(private auditService: AuditService) {}

  @Get()
  async getAuditLogs(@Request() req: any) {
    return this.auditService.getAuditLogs(req.user.companyId);
  }
}
