import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ExpenseService {
  constructor(private prisma: PrismaService) {}

  async getExpenses(companyId: string) {
    return this.prisma.expense.findMany({
      where: { companyId },
      orderBy: { expenseDate: 'desc' },
    });
  }

  async createExpense(companyId: string, dto: {
    title: string;
    category?: string;
    amount: number;
    notes?: string;
  }) {
    return this.prisma.expense.create({
      data: {
        companyId,
        title: dto.title,
        category: dto.category || 'Utilities',
        amount: Number(dto.amount),
        notes: dto.notes,
      },
    });
  }

  async deleteExpense(companyId: string, id: string) {
    return this.prisma.expense.deleteMany({
      where: { id, companyId },
    });
  }
}
