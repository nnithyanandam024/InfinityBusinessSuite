import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { AiService } from './ai.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/ai')
export class AiController {
  constructor(private aiService: AiService) {}

  @Get('forecast')
  async getForecast(@Request() req: any) {
    return this.aiService.getSalesForecast(req.user.companyId);
  }
}
