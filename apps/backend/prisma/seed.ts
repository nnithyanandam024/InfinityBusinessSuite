import { PrismaClient } from '@prisma/client';
import * as crypto from 'crypto';

const prisma = new PrismaClient();

function hashPassword(password: string): string {
  return crypto.createHash('sha256').update(password).digest('hex');
}

async function main() {
  console.log('🌱 Seeding Infinity Business Suite database...');

  // 1. Subscription Plans
  const starterPlan = await prisma.subscriptionPlan.upsert({
    where: { id: 'plan-starter' },
    update: {},
    create: {
      id: 'plan-starter',
      name: 'Starter SME',
      tier: 'STARTER',
      priceMonthly: 999,
      priceYearly: 9990,
      maxUsers: 3,
      maxProducts: 500,
      maxInvoicesPerMonth: 200,
      features: JSON.stringify(['GST Billing', 'Inventory Control', 'Basic Analytics', '3 Users', 'Razorpay Payments']),
    },
  });

  const proPlan = await prisma.subscriptionPlan.upsert({
    where: { id: 'plan-pro' },
    update: {},
    create: {
      id: 'plan-pro',
      name: 'Professional Business',
      tier: 'PROFESSIONAL',
      priceMonthly: 2499,
      priceYearly: 24990,
      maxUsers: 10,
      maxProducts: 5000,
      maxInvoicesPerMonth: 2500,
      features: JSON.stringify(['Full POS Engine', 'Multi-user RBAC', 'Advanced GST Reports', 'Custom Invoices', 'Priority Support']),
    },
  });

  // 2. Demo Company
  const demoCompany = await prisma.company.upsert({
    where: { email: 'demo@infinitytech.com' },
    update: {},
    create: {
      name: 'Infinity Digital Retailers',
      email: 'demo@infinitytech.com',
      phone: '+91 98765 43210',
      gstin: '33AAAAA0000A1Z5',
      address: '100 Technology Boulevard, Suite 4',
      city: 'Chennai',
      state: 'Tamil Nadu',
      pincode: '600001',
      subscriptionStatus: 'ACTIVE',
      planId: proPlan.id,
      subscriptionEndDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
    },
  });

  const passwordHash = hashPassword('Infinity@2026');

  // 3. User Accounts for 3 Distinct Roles
  // Role 1: Super Admin (Infinity Technologies Platform Super Admin)
  await prisma.user.upsert({
    where: { email: 'superadmin@infinitytech.com' },
    update: {},
    create: {
      companyId: demoCompany.id,
      email: 'superadmin@infinitytech.com',
      fullName: 'Infinity Super Admin',
      passwordHash,
      role: 'SUPER_ADMIN',
      phone: '+91 90000 00001',
    },
  });

  // Role 2: Company Owner / Admin
  await prisma.user.upsert({
    where: { email: 'admin@infinitytech.com' },
    update: {},
    create: {
      companyId: demoCompany.id,
      email: 'admin@infinitytech.com',
      fullName: 'Nithyanandam N (Owner)',
      passwordHash,
      role: 'COMPANY_OWNER',
      phone: '+91 98765 43210',
    },
  });

  // Role 3: Employee / Cashier
  await prisma.user.upsert({
    where: { email: 'cashier@infinitytech.com' },
    update: {},
    create: {
      companyId: demoCompany.id,
      email: 'cashier@infinitytech.com',
      fullName: 'Rahul Sharma (Cashier)',
      passwordHash,
      role: 'EMPLOYEE',
      phone: '+91 98765 11111',
    },
  });

  // 4. Demo Categories & Products
  const catElectronics = await prisma.category.create({
    data: { companyId: demoCompany.id, name: 'Electronics & IT', description: 'Smart Devices & Hardware' },
  });

  const catOffice = await prisma.category.create({
    data: { companyId: demoCompany.id, name: 'Office Supplies', description: 'Stationery and Papers' },
  });

  await prisma.product.createMany({
    data: [
      {
        companyId: demoCompany.id,
        name: 'Wireless Ergonomic Mouse',
        sku: 'SKU-LOG-001',
        barcode: '8901234567890',
        hsnCode: '8471',
        categoryId: catElectronics.id,
        buyPrice: 850,
        sellPrice: 1499,
        gstRate: 18.0,
        currentStock: 45,
        minStockAlert: 10,
        unit: 'Pcs',
      },
      {
        companyId: demoCompany.id,
        name: 'USB-C Fast Charger 65W',
        sku: 'SKU-CHG-065',
        barcode: '8901234567891',
        hsnCode: '8504',
        categoryId: catElectronics.id,
        buyPrice: 1100,
        sellPrice: 1999,
        gstRate: 18.0,
        currentStock: 8,
        minStockAlert: 15,
        unit: 'Pcs',
      },
      {
        companyId: demoCompany.id,
        name: 'A4 Premium Copy Paper Box (5 Reams)',
        sku: 'SKU-PAP-A4',
        barcode: '8901234567892',
        hsnCode: '4802',
        categoryId: catOffice.id,
        buyPrice: 950,
        sellPrice: 1250,
        gstRate: 12.0,
        currentStock: 120,
        minStockAlert: 20,
        unit: 'Box',
      },
    ],
  });

  console.log('✅ Seeding complete with 3 distinct user roles!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
