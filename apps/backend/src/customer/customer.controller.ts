import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { CustomerService } from './customer.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/contacts')
export class CustomerController {
  constructor(private customerService: CustomerService) {}

  @Get('customers')
  async getCustomers(@Request() req: any) {
    return this.customerService.getCustomers(req.user.companyId);
  }

  @Post('customers')
  async createCustomer(@Request() req: any, @Body() body: any) {
    return this.customerService.createCustomer(req.user.companyId, body);
  }

  @Get('suppliers')
  async getSuppliers(@Request() req: any) {
    return this.customerService.getSuppliers(req.user.companyId);
  }

  @Post('suppliers')
  async createSupplier(@Request() req: any, @Body() body: any) {
    return this.customerService.createSupplier(req.user.companyId, body);
  }
}
