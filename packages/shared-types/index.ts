export enum UserRole {
  SUPER_ADMIN = 'SUPER_ADMIN',
  COMPANY_OWNER = 'COMPANY_OWNER',
  EMPLOYEE = 'EMPLOYEE',
}

export enum SubscriptionStatus {
  TRIALING = 'TRIALING',
  ACTIVE = 'ACTIVE',
  PAST_DUE = 'PAST_DUE',
  EXPIRED = 'EXPIRED',
  CANCELLED = 'CANCELLED',
}

export enum SubscriptionPlanTier {
  STARTER = 'STARTER',
  PROFESSIONAL = 'PROFESSIONAL',
  ENTERPRISE = 'ENTERPRISE',
}

export enum PaymentStatus {
  PENDING = 'PENDING',
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED',
  REFUNDED = 'REFUNDED',
}

export enum InvoiceStatus {
  DRAFT = 'DRAFT',
  PAID = 'PAID',
  PARTIAL = 'PARTIAL',
  UNPAID = 'UNPAID',
  CANCELLED = 'CANCELLED',
}

export enum GSTType {
  INTRA_STATE = 'INTRA_STATE', // CGST (9%) + SGST (9%)
  INTER_STATE = 'INTER_STATE', // IGST (18%)
}

export interface UserProfile {
  id: string;
  email: string;
  fullName: string;
  role: UserRole;
  companyId: string;
  companyName?: string;
  createdAt: string;
}

export interface Company {
  id: string;
  name: string;
  email: string;
  phone: string;
  gstin?: string;
  address?: string;
  city?: string;
  state?: string;
  pincode?: string;
  subscriptionStatus: SubscriptionStatus;
  planId?: string;
  subscriptionEndDate?: string;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  tier: SubscriptionPlanTier;
  priceMonthly: number;
  priceYearly: number;
  maxUsers: number;
  maxProducts: number;
  maxInvoicesPerMonth: number;
  features: string[];
}

export interface Product {
  id: string;
  companyId: string;
  name: string;
  sku: string;
  barcode?: string;
  hsnCode?: string;
  categoryId?: string;
  categoryName?: string;
  buyPrice: number;
  sellPrice: number;
  gstRate: number; // e.g., 18 for 18%
  currentStock: number;
  minStockAlert: number;
  unit: string; // e.g., 'Pcs', 'Kg', 'Box'
  createdAt: string;
}

export interface Category {
  id: string;
  companyId: string;
  name: string;
  description?: string;
  productCount?: number;
}

export interface Customer {
  id: string;
  companyId: string;
  name: string;
  email?: string;
  phone: string;
  gstin?: string;
  address?: string;
  balance: number; // Positive = Receivable, Negative = Payable
}

export interface InvoiceItem {
  id?: string;
  productId: string;
  productName: string;
  hsnCode?: string;
  quantity: number;
  unitPrice: number;
  discount: number;
  gstRate: number;
  taxableAmount: number;
  cgstAmount: number;
  sgstAmount: number;
  igstAmount: number;
  totalAmount: number;
}

export interface Invoice {
  id: string;
  companyId: string;
  invoiceNumber: string;
  customerId?: string;
  customerName: string;
  customerPhone?: string;
  customerGstin?: string;
  invoiceDate: string;
  dueDate?: string;
  gstType: GSTType;
  subtotal: number;
  totalDiscount: number;
  totalTax: number;
  cgstTotal: number;
  sgstTotal: number;
  igstTotal: number;
  grandTotal: number;
  status: InvoiceStatus;
  paymentMethod: string;
  items: InvoiceItem[];
  createdAt: string;
}

export interface RazorpayOrderResponse {
  id: string;
  amount: number;
  currency: string;
  receipt: string;
  keyId: string;
}
