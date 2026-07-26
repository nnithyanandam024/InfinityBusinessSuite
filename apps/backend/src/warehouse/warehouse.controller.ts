import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { WarehouseService } from './warehouse.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/warehouses')
export class WarehouseController {
  constructor(private warehouseService: WarehouseService) {}

  @Get()
  async getWarehouses(@Request() req: any) {
    return this.warehouseService.getWarehouses(req.user.companyId);
  }

  @Post()
  async createWarehouse(@Request() req: any, @Body() body: any) {
    return this.warehouseService.createWarehouse(req.user.companyId, body);
  }
}
