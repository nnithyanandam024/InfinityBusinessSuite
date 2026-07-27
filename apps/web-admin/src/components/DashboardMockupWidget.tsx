import React from 'react';
import { Search, ChevronDown, ShoppingBag, ShieldCheck, Sparkles, Building2, Package, ArrowUpRight } from 'lucide-react';

export const DashboardMockupWidget: React.FC = () => {
  return (
    <div className="relative w-full max-w-[640px] h-[460px] select-none flex items-center justify-center mx-auto font-sans">
      {/* SVG Connecting Wavy Path */}
      <div className="absolute inset-0 z-0 pointer-events-none opacity-60">
        <svg viewBox="0 0 600 400" className="w-full h-full">
          <path
            d="M 50,300 C 150,320 200,180 300,280 C 400,380 480,180 580,240"
            fill="none"
            stroke="#2563EB"
            strokeWidth="3"
            strokeDasharray="8 8"
          />
          <circle cx="300" cy="280" r="6" fill="#2563EB" className="animate-ping" />
          <circle cx="480" cy="225" r="4" fill="#2563EB" />
        </svg>
      </div>

      {/* LEFT CARD: GST Sales & POS Billing */}
      <div className="absolute left-2 top-[10%] w-[230px] bg-white border border-slate-200 rounded-card p-4 shadow-soft z-10 hover:shadow-hover transition-all">
        <div className="flex items-center justify-between mb-3 border-b border-slate-100 pb-2">
          <div className="flex items-center space-x-1.5">
            <ShoppingBag className="w-4 h-4 text-primary" />
            <span className="font-sans font-bold text-xs text-slate-800">GST Sales & POS</span>
          </div>
          <span className="w-2 h-2 rounded-full bg-emerald-500 animate-ping" />
        </div>

        {/* Metric 1 */}
        <div className="space-y-1 mb-3">
          <div className="text-[11px] font-sans font-semibold text-slate-400">Monthly Revenue</div>
          <div className="flex items-baseline justify-between">
            <span className="text-xl font-bold font-sans text-slate-900">₹24,980</span>
            <span className="text-[10px] font-bold font-sans text-emerald-600 bg-emerald-50 border border-emerald-100 px-1.5 py-0.5 rounded-full flex items-center">
              +12.5% <ArrowUpRight className="w-3 h-3 ml-0.5" />
            </span>
          </div>
        </div>

        {/* Metric 2 */}
        <div className="space-y-1 mb-3">
          <div className="text-[11px] font-sans font-semibold text-slate-400">GST Collected</div>
          <div className="flex items-baseline justify-between">
            <span className="text-xl font-bold font-sans text-slate-900">₹4,496</span>
            <span className="text-[10px] font-bold font-sans text-primary bg-blue-50 border border-blue-100 px-1.5 py-0.5 rounded-full">
              CGST/SGST
            </span>
          </div>
        </div>

        {/* SVG Sparkline Area Chart */}
        <div className="w-full h-14 pt-1">
          <svg className="w-full h-full" viewBox="0 0 200 60">
            <defs>
              <linearGradient id="erp-blue" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#2563EB" stopOpacity="0.4" />
                <stop offset="100%" stopColor="#2563EB" stopOpacity="0.0" />
              </linearGradient>
            </defs>
            <path
              d="M 0,60 C 30,45 60,50 90,30 C 120,10 150,40 200,15 L 200,60 L 0,60 Z"
              fill="url(#erp-blue)"
            />
            <path
              d="M 0,60 C 30,45 60,50 90,30 C 120,10 150,40 200,15"
              fill="none"
              stroke="#2563EB"
              strokeWidth="2.5"
            />
          </svg>
        </div>
      </div>

      {/* OVERLAY INFINITY BRAND BADGE: Floating between cards */}
      <div className="absolute left-[38%] top-[40%] bg-navy text-white px-3.5 py-2.5 rounded-2xl shadow-hover border border-slate-800 z-30 transition-transform hover:scale-110 flex items-center space-x-1.5">
        <span className="font-extrabold text-primary text-xl">∞</span>
        <span className="text-[10px] font-bold uppercase tracking-wider text-slate-200">SaaS ERP</span>
      </div>

      {/* RIGHT CARD: Main ERP Inventory & Store Operations Screen */}
      <div className="absolute right-2 top-[8%] w-[320px] bg-white border border-slate-200 rounded-card p-4 shadow-hover z-20">
        <div className="flex items-center justify-between mb-4 pb-3 border-b border-slate-100">
          <div className="flex items-center space-x-1.5 bg-slate-50 border border-slate-200 rounded-lg px-2.5 py-1 w-[140px]">
            <Search className="w-3.5 h-3.5 text-slate-400" />
            <span className="text-[10px] text-slate-400 font-sans">Search SKU...</span>
          </div>
          <div className="flex items-center space-x-1 text-slate-500 border border-slate-200 rounded-lg px-2 py-1 text-[10px] font-semibold bg-white cursor-pointer hover:bg-slate-50">
            <span>This month</span>
            <ChevronDown className="w-3 h-3" />
          </div>
        </div>

        {/* Inventory SKUs & Radial Stock Fill */}
        <div className="grid grid-cols-12 gap-2 mb-5">
          <div className="col-span-7 space-y-1">
            <span className="text-[11px] font-sans font-semibold text-slate-400 block">Catalog Products</span>
            <div className="flex items-baseline space-x-2">
              <span className="text-2xl font-bold font-sans text-slate-900">1,480 SKUs</span>
            </div>
            <span className="text-[10px] font-bold font-sans text-emerald-600 bg-emerald-50 border border-emerald-100 px-1.5 py-0.5 rounded-full inline-flex items-center">
              +16.2% In Stock
            </span>
          </div>

          <div className="col-span-5 flex items-center justify-center relative">
            <svg className="w-16 h-16 transform -rotate-90">
              <circle cx="32" cy="32" r="24" stroke="#F1F5F9" strokeWidth="6" fill="transparent" />
              <circle
                cx="32"
                cy="32"
                r="24"
                stroke="#2563EB"
                strokeWidth="6"
                fill="transparent"
                strokeDasharray={2 * Math.PI * 24}
                strokeDashoffset={2 * Math.PI * 24 * (1 - 0.94)}
              />
            </svg>
            <div className="absolute inset-0 flex items-center justify-center">
              <span className="font-sans font-bold text-xs text-slate-900">94%</span>
            </div>
          </div>
        </div>

        {/* Bottom Weekly POS Billing Trend */}
        <div className="space-y-2">
          <div className="flex items-center justify-between text-[10px] font-semibold text-slate-400 font-sans">
            <span>MON</span>
            <span>TUE</span>
            <span>WED</span>
            <span>THU</span>
            <span>FRI</span>
            <span>SAT</span>
            <span>SUN</span>
          </div>
          <div className="flex items-end justify-between h-14 px-1">
            {[40, 60, 45, 80, 55, 95, 70].map((height, i) => (
              <div key={i} className="w-2.5 bg-slate-100 rounded-full h-full flex items-end">
                <div
                  style={{ height: `${height}%` }}
                  className="w-full bg-primary rounded-full transition-all duration-700"
                />
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* FLOATING CARD 1: SME Tenant Stores */}
      <div className="absolute left-[36%] bottom-[5%] w-[135px] bg-white border border-slate-200 rounded-card p-3 shadow-soft z-20">
        <div className="flex items-center space-x-1 text-slate-400 mb-0.5">
          <Building2 className="w-3 h-3 text-primary" />
          <span className="text-[10px] font-sans font-semibold">Active Tenants</span>
        </div>
        <div className="text-base font-bold font-sans text-slate-900 mb-1">128 Stores</div>
        <div className="h-5">
          <svg className="w-full h-full" viewBox="0 0 100 30">
            <path d="M 0,20 Q 25,5 50,20 T 100,10" fill="none" stroke="#2563EB" strokeWidth="2" />
          </svg>
        </div>
      </div>

      {/* FLOATING CARD 2: Cloud Sync & Razorpay Card */}
      <div className="absolute right-6 bottom-[8%] w-[165px] bg-navy text-white border border-slate-800 rounded-card p-3 shadow-hover z-30">
        <div className="flex items-center justify-between mb-1.5">
          <span className="text-[10px] font-semibold text-slate-400 font-sans">Cloud Backup</span>
          <span className="text-[10px] font-bold font-sans text-emerald-400">Online 100%</span>
        </div>
        <div className="text-[10px] text-slate-300 font-semibold flex items-center justify-between pt-1 border-t border-slate-800">
          <span>Razorpay Billing</span>
          <ShieldCheck className="w-3.5 h-3.5 text-primary" />
        </div>
      </div>
    </div>
  );
};
