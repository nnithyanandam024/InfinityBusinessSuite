import React from 'react';
import { LayoutDashboard, ShoppingCart, Package, Users, BarChart3, CreditCard, DollarSign, Settings, UserCheck, ShieldCheck, Barcode, Building2, Crown } from 'lucide-react';

interface SidebarProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
  userRole?: string;
}

export const Sidebar: React.FC<SidebarProps> = ({ activeTab, setActiveTab, userRole = 'COMPANY_OWNER' }) => {
  const allMenuItems = [
    { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard, roles: ['COMPANY_OWNER'] },
    { id: 'billing', label: 'Point of Sale (POS)', icon: ShoppingCart, badge: 'GST', roles: ['COMPANY_OWNER', 'EMPLOYEE'] },
    { id: 'inventory', label: 'Inventory', icon: Package, roles: ['COMPANY_OWNER', 'EMPLOYEE'] },
    { id: 'barcode', label: 'Barcode Print Station', icon: Barcode, roles: ['COMPANY_OWNER', 'EMPLOYEE'] },
    { id: 'warehouses', label: 'Warehouses', icon: Building2, roles: ['COMPANY_OWNER'] },
    { id: 'customers', label: 'Customers & Suppliers', icon: Users, roles: ['COMPANY_OWNER'] },
    { id: 'expenses', label: 'Expenses', icon: DollarSign, roles: ['COMPANY_OWNER'] },
    { id: 'reports', label: 'GST & Financial Reports', icon: BarChart3, roles: ['COMPANY_OWNER'] },
    { id: 'users', label: 'Team Members', icon: UserCheck, roles: ['COMPANY_OWNER'] },
    { id: 'audit', label: 'Audit Logs', icon: ShieldCheck, roles: ['COMPANY_OWNER', 'SUPER_ADMIN'] },
    { id: 'superadmin', label: 'SaaS Super Admin', icon: Crown, badge: 'Multi-SaaS', roles: ['SUPER_ADMIN'] },
    { id: 'subscription', label: 'Subscription', icon: CreditCard, roles: ['COMPANY_OWNER'] },
    { id: 'settings', label: 'Settings', icon: Settings, roles: ['COMPANY_OWNER'] },
  ];

  // Filter menu items by logged in user's role
  const visibleMenuItems = allMenuItems.filter((item) =>
    item.roles.includes(userRole)
  );

  return (
    <aside className="w-64 bg-white border-r border-slate-200 p-4 flex flex-col justify-between min-h-[calc(100vh-4rem)] font-sans">
      <div className="space-y-1">
        {/* Role Access Pill */}
        <div className="px-3 py-1.5 mb-3 rounded-xl bg-slate-50 border border-slate-200 flex items-center justify-between text-[10px] font-bold">
          <span className="text-slate-400 uppercase tracking-wider">Access Scope</span>
          <span
            className={`px-2 py-0.5 rounded-full ${
              userRole === 'SUPER_ADMIN'
                ? 'bg-purple-50 text-purple-600 border border-purple-100'
                : userRole === 'EMPLOYEE'
                ? 'bg-amber-50 text-amber-600 border border-amber-100'
                : 'bg-blue-50 text-primary border border-blue-100'
            }`}
          >
            {userRole === 'SUPER_ADMIN' ? 'Super Admin' : userRole === 'EMPLOYEE' ? 'Cashier Employee' : 'Company Admin'}
          </span>
        </div>

        {visibleMenuItems.map((item) => {
          const Icon = item.icon;
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              onClick={() => setActiveTab(item.id)}
              className={`w-full flex items-center justify-between px-3 py-2.5 rounded-xl font-medium text-xs transition-all ${
                isActive
                  ? 'bg-primary text-white font-semibold shadow-hover'
                  : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'
              }`}
            >
              <div className="flex items-center space-x-3">
                <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-slate-400'}`} />
                <span>{item.label}</span>
              </div>
              {item.badge && (
                <span
                  className={`text-[9px] font-bold px-1.5 py-0.5 rounded-full ${
                    isActive ? 'bg-white/20 text-white' : 'bg-blue-50 text-primary border border-blue-100'
                  }`}
                >
                  {item.badge}
                </span>
              )}
            </button>
          );
        })}
      </div>

      <div className="pt-4 border-t border-slate-100 px-3 text-[11px] text-slate-400 flex items-center justify-between">
        <span>Infinity Technologies</span>
        <span className="font-semibold text-slate-500">v3.1.0</span>
      </div>
    </aside>
  );
};
