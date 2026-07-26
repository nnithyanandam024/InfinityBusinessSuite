import React from 'react';
import { Search, ChevronDown, Bell, LogOut, CreditCard } from 'lucide-react';
import { clearAuthToken } from '../services/api';

interface NavbarProps {
  user: any;
  company: any;
  onOpenSubscriptionModal: () => void;
}

export const Navbar: React.FC<NavbarProps> = ({ user, company, onOpenSubscriptionModal }) => {
  const handleLogout = () => {
    clearAuthToken();
    window.location.reload();
  };

  return (
    <header className="h-16 bg-white border-b border-slate-200 px-6 flex items-center justify-between sticky top-0 z-30 shadow-xs">
      {/* Brand Text Only Logo */}
      <div className="flex items-center">
        <span className="font-extrabold text-slate-900 text-lg tracking-tight font-sans">
          Infinity <span className="text-primary font-normal">Business Suite</span>
        </span>
      </div>

      {/* Center Search Bar */}
      <div className="hidden md:flex items-center space-x-3">
        <div className="flex items-center space-x-2 bg-slate-50 border border-slate-200 rounded-xl px-3 py-1.5 w-64 focus-within:ring-2 focus-within:ring-primary/20 transition-all">
          <Search className="w-4 h-4 text-slate-400" />
          <input
            type="text"
            placeholder="Search..."
            className="bg-transparent text-xs text-slate-700 outline-none w-full placeholder:text-slate-400"
          />
        </div>
        <div className="flex items-center space-x-1.5 border border-slate-200 rounded-xl px-3 py-1.5 text-xs font-semibold text-slate-600 bg-white hover:bg-slate-50 cursor-pointer transition-colors">
          <span>This month</span>
          <ChevronDown className="w-3.5 h-3.5 text-slate-400" />
        </div>
      </div>

      {/* Right User & Controls */}
      <div className="flex items-center space-x-4">
        {/* Simple Subscription Button */}
        <button
          onClick={onOpenSubscriptionModal}
          className="flex items-center space-x-1.5 px-3 py-1.5 rounded-xl text-xs font-bold bg-slate-100 text-slate-700 hover:bg-slate-200 border border-slate-200 transition-all"
        >
          <CreditCard className="w-3.5 h-3.5 text-slate-500" />
          <span>Subscription</span>
        </button>

        <button className="p-2 text-slate-400 hover:text-slate-600 rounded-xl hover:bg-slate-100 relative transition-colors">
          <Bell className="w-4 h-4" />
          <span className="w-2 h-2 rounded-full bg-primary absolute top-2 right-2 animate-ping" />
        </button>

        <div className="h-6 w-px bg-slate-200" />

        {/* User Profile */}
        <div className="flex items-center space-x-3">
          <div className="w-8 h-8 rounded-full bg-navy text-white flex items-center justify-center font-bold text-xs shadow-xs">
            {user?.fullName ? user.fullName[0].toUpperCase() : 'U'}
          </div>
          <div className="hidden lg:block text-left">
            <div className="text-xs font-bold text-slate-800 leading-tight">{user?.fullName || 'User'}</div>
            <div className="text-[10px] text-slate-400 font-medium">{company?.name || 'Company'}</div>
          </div>
          <button
            onClick={handleLogout}
            title="Logout"
            className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-rose-50 transition-colors"
          >
            <LogOut className="w-4 h-4" />
          </button>
        </div>
      </div>
    </header>
  );
};
