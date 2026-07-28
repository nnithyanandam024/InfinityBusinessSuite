import { Module } from '@nestjs/common';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { SubscriptionModule } from './subscription/subscription.module';
import { ProductModule } from './product/product.module';
import { BillingModule } from './billing/billing.module';
import { AnalyticsModule } from './analytics/analytics.module';
import { CustomerModule } from './customer/customer.module';
import { ReportsModule } from './reports/reports.module';
import { ExpenseModule } from './expense/expense.module';
import { SettingsModule } from './settings/settings.module';
import { UsersModule } from './users/users.module';
import { AiModule } from './ai/ai.module';
import { AuditModule } from './audit/audit.module';
import { WarehouseModule } from './warehouse/warehouse.module';
import { DiscountsModule } from './discounts/discounts.module';
import { SuperAdminModule } from './super-admin/super-admin.module';
import { KhataModule } from './khata/khata.module';
import { EventsModule } from './events/events.module';

@Module({
  imports: [
    PrismaModule,
    AuthModule,
    SubscriptionModule,
    ProductModule,
    BillingModule,
    AnalyticsModule,
    CustomerModule,
    ReportsModule,
    ExpenseModule,
    SettingsModule,
    UsersModule,
    AiModule,
    AuditModule,
    WarehouseModule,
    DiscountsModule,
    SuperAdminModule,
    KhataModule,
    EventsModule,
  ],
})
export class AppModule {}
