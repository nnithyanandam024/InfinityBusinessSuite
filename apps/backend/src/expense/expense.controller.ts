import { Controller, Get, Post, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ExpenseService } from './expense.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/expenses')
export class ExpenseController {
  constructor(private expenseService: ExpenseService) {}

  @Get()
  async getExpenses(@Request() req: any) {
    return this.expenseService.getExpenses(req.user.companyId);
  }

  @Post()
  async createExpense(@Request() req: any, @Body() body: any) {
    return this.expenseService.createExpense(req.user.companyId, body);
  }

  @Delete(':id')
  async deleteExpense(@Request() req: any, @Param('id') id: string) {
    return this.expenseService.deleteExpense(req.user.companyId, id);
  }
}
