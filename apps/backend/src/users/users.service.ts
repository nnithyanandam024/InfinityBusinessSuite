import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  private hashPassword(password: string): string {
    return crypto.createHash('sha256').update(password).digest('hex');
  }

  async getCompanyUsers(companyId: string) {
    return this.prisma.user.findMany({
      where: { companyId },
      select: {
        id: true,
        email: true,
        fullName: true,
        role: true,
        phone: true,
        createdAt: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async createEmployee(companyId: string, dto: {
    fullName: string;
    email: string;
    password: string;
    phone?: string;
    role?: string;
  }) {
    const existing = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existing) {
      throw new BadRequestException('User email already exists');
    }

    const passwordHash = this.hashPassword(dto.password);

    const user = await this.prisma.user.create({
      data: {
        companyId,
        email: dto.email,
        fullName: dto.fullName,
        passwordHash,
        role: dto.role || 'EMPLOYEE',
        phone: dto.phone,
      },
    });

    // Log audit trail
    await this.prisma.auditLog.create({
      data: {
        companyId,
        userId: user.id,
        action: 'EMPLOYEE_CREATED',
        details: `Created user account for ${user.email} (${user.role})`,
      },
    });

    return {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      role: user.role,
      phone: user.phone,
    };
  }

  async deleteUser(companyId: string, userId: string) {
    return this.prisma.user.deleteMany({
      where: { id: userId, companyId },
    });
  }
}
