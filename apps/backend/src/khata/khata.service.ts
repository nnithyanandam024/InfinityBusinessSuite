import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { EventsGateway } from '../events/events.gateway';

@Injectable()
export class KhataService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly eventsGateway: EventsGateway,
  ) {}

  async createEntry(companyId: String, dto: { customerId: string; type: 'DEBIT' | 'CREDIT'; amount: number; referenceType?: string; referenceId?: string; note?: string }) {
    const customer = await this.prisma.customer.findFirst({
      where: { id: dto.customerId, companyId: String(companyId) },
    });

    if (!customer) {
      throw new NotFoundException('Customer not found');
    }

    const delta = dto.type === 'DEBIT' ? dto.amount : -dto.amount;
    const newBalance = customer.balance + delta;

    // Transaction: Create Khata Entry & update Customer running balance
    const [entry] = await this.prisma.$transaction([
      this.prisma.khataEntry.create({
        data: {
          companyId: String(companyId),
          customerId: dto.customerId,
          type: dto.type,
          amount: dto.amount,
          balanceAfter: newBalance,
          referenceType: dto.referenceType || (dto.type === 'DEBIT' ? 'INVOICE' : 'PAYMENT'),
          referenceId: dto.referenceId,
          note: dto.note,
        },
      }),
      this.prisma.customer.update({
        where: { id: dto.customerId },
        data: { balance: newBalance },
      }),
    ]);

    // Emit Real-Time WebSocket event
    this.eventsGateway.emitToCompany(String(companyId), 'khata.entry.created', {
      customerId: dto.customerId,
      customerName: customer.name,
      entry,
      newBalance,
    });

    return entry;
  }

  async getCustomerLedger(companyId: String, customerId: string) {
    const customer = await this.prisma.customer.findFirst({
      where: { id: customerId, companyId: String(companyId) },
      include: {
        khataEntries: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });

    if (!customer) {
      throw new NotFoundException('Customer account not found');
    }

    return customer;
  }
}
