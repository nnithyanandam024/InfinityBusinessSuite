# 🌐 Infinity Business Suite (IBS)

> **Enterprise-Grade Multi-Tenant Cloud ERP, Point of Sale (POS), Multi-Warehouse Inventory, WhatsApp CRM & Cross-Platform Mobile Application**

[![GitHub Repository](https://img.shields.io/badge/GitHub-InfinityBusinessSuite-blue?logo=github)](https://github.com/nnithyanandam024/InfinityBusinessSuite.git)
[![NestJS](https://img.shields.io/badge/Backend-NestJS%2011-E0234E?logo=nestjs)](https://nestjs.com/)
[![React](https://img.shields.io/badge/Web%20Admin-React%2019-61DAFB?logo=react)](https://react.dev/)
[![Flutter](https://img.shields.io/badge/Mobile%20App-Flutter%203.x-02569B?logo=flutter)](https://flutter.dev/)
[![Prisma](https://img.shields.io/badge/ORM-Prisma%20PostgreSQL-2D3748?logo=prisma)](https://www.prisma.io/)

---

## 🚀 System Architecture Overview

Infinity Business Suite (IBS) is a unified monorepo platform designed for multi-location SME retailers, wholesalers, and multi-tenant SaaS providers:

```
Infinity Business Suite (Monorepo)
├── apps/backend/         # NestJS 11 REST API, Prisma ORM, JWT Auth, Multi-Tenant Guards
├── apps/web-admin/       # React 19 + Vite Web Admin Dashboard & Multi-SaaS Super Admin Portal
└── apps/mobile/          # Flutter 3.x Cross-Platform App for Android & iOS (Modular Clean Architecture)
```

---

## 👥 Strict 3-Tier Role-Based Access Control (RBAC)

The platform enforces strict role separation across Web Admin and Mobile interfaces:

| Role | Access Scope | Accessible Interfaces |
| :--- | :--- | :--- |
| **`SUPER_ADMIN`** | Platform SaaS Owner, Tenant Directory, Subscription Controls, MRR Metrics | Multi-Tenant SaaS Super Admin Portal |
| **`COMPANY_OWNER`** | Full Store ERP, Financial Ledgers, Operating Expenses, Audit Logs, Data Backups | Complete Web Admin ERP & Mobile App |
| **`EMPLOYEE` (Cashier)** | Restricted strictly to POS Billing Counter & Inventory Catalog View | POS Billing Counter & SKU Catalog |

### 🔑 Demo Login Credentials

- **Super Admin**: `superadmin@infinitytech.com` / `Infinity@2026`
- **Company Owner**: `admin@infinitytech.com` / `Infinity@2026`
- **Cashier Employee**: `cashier@infinitytech.com` / `Infinity@2026`

---

## 🖥️ 1. Web Admin Dashboard (`apps/web-admin`)

### Key Features Delivered
1. **GST POS Billing Counter**: Real-time invoice generation with promo coupon codes (`WELCOME10` 10% OFF, `FLAT200` ₹200 OFF).
2. **Barcode Label Print Station**: Thermal label sheet generator (50mm × 25mm labels) with `@media print` CSS isolation.
3. **Multi-Warehouse Locations**: Multi-branch stock tracking and store manager assignments.
4. **Multi-Tenant SaaS Super Admin Portal**: Platform MRR metrics (₹4,85,000/mo), tenant company directory, 1-click **Suspend**, **Reactivate**, and **+14 Days Trial Extension** controls.
5. **ERP-Aligned Login Visuals**: Text-only brand logo with dynamic sales KPI widgets.
6. **Operating Expense & Financials**: Expense tracking, customer/supplier ledgers, and JSON data backup engine.

---

## 📱 2. Flutter Mobile Application (`apps/mobile`)

### Clean Modular Architecture
```
apps/mobile/lib/
├── main.dart                      # Entry point with splash route
├── core/
│   ├── constants/app_colors.dart  # Corporate brand tokens
│   ├── models/                    # DTO Data Models
│   └── services/                  # HTTP REST API & WhatsApp Services
└── screens/
    ├── splash/splash_screen.dart  # Animated Splash with glowing infinity symbol
    ├── auth/login_screen.dart     # JWT Login & Biometric Unlock
    ├── pos/pos_billing_tab.dart   # POS Counter, Quantity Adjusters & Coupon Engine
    ├── inventory/inventory_tab.dart # Live SKU Catalog, Category Filters & Stock Adjuster
    ├── ledgers/ledgers_tab.dart   # Customer Receivables, Payables & Payment Collection
    ├── whatsapp/whatsapp_hub_screen.dart # Dedicated WhatsApp CRM & Batch Broadcast Hub
    └── profile/profile_tab.dart   # Account Info & Store Profile Editor
```

### Key Mobile Features Delivered
1. **Production REST API Client**: Connects directly to NestJS backend (`http://localhost:4000/api/v1` / `http://10.0.2.2:4000/api/v1`).
2. **WhatsApp Business & CRM Automation**:
   - Customer Contact Selector Modal.
   - Dynamic Embedded **UPI Pay Links** (`upi://pay?pa=store@upi&am=...`).
   - Multi-Customer Batch Broadcast Dispatcher.
   - Templates: Invoice Receipts, Payment Reminders, Promo Coupons, Shipment Tracking, Supplier Restock.
3. **Camera Barcode Scanner Viewfinder**: Continuous camera viewfinder for barcode checkout.
4. **Bluetooth Thermal Receipt Printing**: One-tap printing for 2-inch/3-inch thermal printers.
5. **Biometric Fingerprint Unlock**: Fast cashier authentication.

---

## 🛠️ Execution & Development Commands

### 1. NestJS Backend Server (`http://localhost:4000`)
```powershell
cd "d:\Projects\Infinity Business Suite\apps\backend"
npm run dev
```

### 2. React Web Admin Dashboard (`http://localhost:3000`)
```powershell
cd "d:\Projects\Infinity Business Suite\apps\web-admin"
npm run dev
```

### 3. Build Flutter Mobile Android APK (`app-debug.apk`)
```powershell
cd "d:\Projects\Infinity Business Suite\apps\mobile"
flutter build apk --debug
```
📁 **Generated Output File**: `apps/mobile/build/app/outputs/flutter-apk/app-debug.apk`

---

## 📑 REST API Endpoint Reference

| Method | Endpoint | Description | Role Required |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/v1/auth/login` | JWT User Authentication | Public |
| `GET` | `/api/v1/products` | Fetch Product Catalog | All Roles |
| `POST` | `/api/v1/billing/invoices` | Create Invoice & Decrement Stock | `COMPANY_OWNER`, `EMPLOYEE` |
| `GET` | `/api/v1/customers` | Fetch Customer Ledgers | `COMPANY_OWNER` |
| `GET` | `/api/v1/super-admin/mrr` | SaaS MRR Analytics | `SUPER_ADMIN` |
| `POST` | `/api/v1/super-admin/tenants/:id/suspend` | Suspend SaaS Tenant | `SUPER_ADMIN` |

---

## 📦 Repository & Commits
- **GitHub Repository**: [https://github.com/nnithyanandam024/InfinityBusinessSuite.git](https://github.com/nnithyanandam024/InfinityBusinessSuite.git)
- **Branch**: `main`
