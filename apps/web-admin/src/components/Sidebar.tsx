import React from 'react';
import { LayoutDashboard, ShoppingCart, Package, Users, BarChart3, CreditCard, DollarSign, Settings, UserCheck, ShieldCheck } from 'lucide-react';

interface SidebarProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
}

export const Sidebar: React.FC<SidebarProps> = ({ activeTab, setActiveTab }) => {
  const menuItems = [
    { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
    { id: 'billing', label: 'Point of Sale (POS)', icon: ShoppingCart, badge: 'GST' },
    { id: 'inventory', label: 'Inventory', icon: Package },
    { id: 'customers', label: 'Customers & Suppliers', icon: Users },
    { id: 'expenses', label: 'Expenses', icon: DollarSign },
    { id: 'reports', label: 'GST & Financial Reports', icon: BarChart3 },
    { id: 'users', label: 'Team Members', icon: UserCheck },
    { id: 'audit', label: 'Audit Logs', icon: ShieldCheck },
    { id: 'subscription', label: 'Subscription', icon: CreditCard },
    { id: 'settings', label: 'Settings', icon: Settings },
  ];

  return (
    <aside className="w-64 bg-white border-r border-slate-200 p-4 flex flex-col justify-between min-h-[calc(100vh-4rem)]">
      <div className="space-y-1">
        {menuItems.map((item) => {
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
        <span className="font-semibold text-slate-500">v2.0.0</span>
      </div>
    </aside>
  );
};
