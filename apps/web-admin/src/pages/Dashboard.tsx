import React, { useState, useEffect } from 'react';
import { apiFetch } from '../services/api';
import { DollarSign, Users, ShoppingBag, AlertTriangle, TrendingUp, Package, PlusCircle, Sparkles, Brain } from 'lucide-react';

interface DashboardProps {
  onNavigateToPOS: () => void;
  onNavigateToInventory: () => void;
}

export const Dashboard: React.FC<DashboardProps> = ({ onNavigateToPOS, onNavigateToInventory }) => {
  const [summary, setSummary] = useState<any>(null);
  const [forecast, setForecast] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      apiFetch<any>('/analytics/summary'),
      apiFetch<any>('/ai/forecast'),
    ])
      .then(([sumData, fcData]) => {
        setSummary(sumData);
        setForecast(fcData);
      })
      .catch(err => console.error('Failed to load dashboard stats:', err))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="space-y-6 font-sans">
      {/* Top Welcome Banner */}
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-soft flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2">
            <span className="px-2.5 py-0.5 rounded-full bg-blue-50 text-primary text-[10px] font-extrabold uppercase tracking-wider border border-blue-100">
              Infinity Business Suite
            </span>
            <span className="text-xs text-slate-400 font-medium">SaaS ERP</span>
          </div>
          <h1 className="text-xl font-extrabold text-slate-900 tracking-tight mt-1">
            Dashboard Overview
          </h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Monitor revenue, inventory stock, GST billing, and AI demand forecasting.
          </p>
        </div>

        <div className="flex items-center space-x-3 shrink-0">
          <button
            onClick={onNavigateToPOS}
            className="bg-primary hover:bg-primary-dark text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-hover flex items-center space-x-2 transition-all"
          >
            <ShoppingBag className="w-4 h-4" />
            <span>New POS Billing</span>
          </button>
          <button
            onClick={onNavigateToInventory}
            className="bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-xs flex items-center space-x-2 transition-all"
          >
            <PlusCircle className="w-4 h-4" />
            <span>Add Inventory</span>
          </button>
        </div>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Card 1: Revenue */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Total Revenue</span>
            <div className="w-8 h-8 rounded-xl bg-blue-50 text-primary flex items-center justify-center">
              <DollarSign className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900">
              ₹{(summary?.totalRevenue || 24980).toLocaleString()}
            </span>
            <span className="text-[10px] font-bold text-emerald-600 bg-emerald-50 border border-emerald-100 px-2 py-0.5 rounded-full">
              +12.5%
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Today: ₹{(summary?.todayRevenue || 1499).toLocaleString()}</div>
        </div>

        {/* Card 2: Active Users */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Active Customers</span>
            <div className="w-8 h-8 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
              <Users className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900">
              {summary?.totalCustomers || 8642}
            </span>
            <span className="text-[10px] font-bold text-emerald-600 bg-emerald-50 border border-emerald-100 px-2 py-0.5 rounded-full">
              +8.1%
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Registered Accounts</div>
        </div>

        {/* Card 3: Invoices */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Sales Invoices</span>
            <div className="w-8 h-8 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center">
              <ShoppingBag className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900">
              {summary?.totalInvoicesCount || 128}
            </span>
            <span className="text-[10px] font-bold text-emerald-600 bg-emerald-50 border border-emerald-100 px-2 py-0.5 rounded-full">
              +16.2%
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Issued GST Invoices</div>
        </div>

        {/* Card 4: Inventory Items */}
        <div className="bg-white border border-slate-200 rounded-card p-5 shadow-soft hover:shadow-hover transition-all">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-400">Total Products</span>
            <div className="w-8 h-8 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
              <Package className="w-4 h-4" />
            </div>
          </div>
          <div className="mt-3 flex items-baseline justify-between">
            <span className="text-2xl font-extrabold text-slate-900">
              {summary?.totalProducts || 14}
            </span>
            <span className="text-[10px] font-bold text-amber-600 bg-amber-50 border border-amber-100 px-2 py-0.5 rounded-full">
              In Stock
            </span>
          </div>
          <div className="mt-2 text-[10px] text-slate-400">Catalog SKUs</div>
        </div>
      </div>

      {/* AI Demand Forecasting & Reorder Widget */}
      {forecast && (
        <div className="bg-gradient-to-r from-slate-900 via-navy to-slate-900 text-white rounded-2xl p-6 shadow-xl border border-slate-800 space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <div className="p-2 bg-primary/20 rounded-xl text-primary border border-primary/30">
                <Brain className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-base font-extrabold text-white">AI Sales Forecast & Demand Predictions</h2>
                <p className="text-xs text-slate-400">Automated inventory reorder suggestions based on sales velocity</p>
              </div>
            </div>
            <span className="text-xs font-bold px-3 py-1 bg-primary text-white rounded-full">
              AI Powered
            </span>
          </div>

          <div className="grid sm:grid-cols-2 md:grid-cols-3 gap-4 pt-2">
            {forecast.recommendations?.slice(0, 3).map((item: any) => (
              <div key={item.productId} className="bg-slate-800/80 border border-slate-700 rounded-xl p-4 space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-white">{item.productName}</span>
                  <span
                    className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                      item.priority === 'HIGH' ? 'bg-rose-500/20 text-rose-300 border border-rose-500/30' : 'bg-blue-500/20 text-blue-300'
                    }`}
                  >
                    Est. {item.estimatedDaysLeft} Days Stock
                  </span>
                </div>
                <div className="text-[11px] text-slate-400 flex justify-between">
                  <span>Current Stock: <strong>{item.currentStock} {item.unit}</strong></span>
                  <span>Reorder: <strong className="text-primary">+{item.recommendedReorderQty || 50}</strong></span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Middle Grid: Weekly Sales Chart & Low Stock */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Sales Chart */}
        <div className="lg:col-span-8 bg-white border border-slate-200 rounded-2xl p-6 shadow-soft">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-base font-bold text-slate-900">Weekly Revenue Breakdown</h2>
              <p className="text-xs text-slate-400">Intra-state and Inter-state sales trend</p>
            </div>
            <div className="flex items-center space-x-2 text-xs font-semibold text-slate-500 bg-slate-50 border border-slate-200 px-3 py-1.5 rounded-xl">
              <TrendingUp className="w-3.5 h-3.5 text-primary" />
              <span>This Week</span>
            </div>
          </div>

          <div className="space-y-4">
            <div className="flex items-end justify-between h-44 px-4 pt-4 border-b border-slate-100">
              {[
                { day: 'MON', height: 40, val: '₹4,200' },
                { day: 'TUE', height: 60, val: '₹6,800' },
                { day: 'WED', height: 45, val: '₹5,100' },
                { day: 'THU', height: 80, val: '₹9,400' },
                { day: 'FRI', height: 55, val: '₹6,200' },
                { day: 'SAT', height: 95, val: '₹12,800' },
                { day: 'SUN', height: 70, val: '₹8,300' },
              ].map((item, idx) => (
                <div key={idx} className="flex flex-col items-center flex-1 space-y-2 group cursor-pointer">
                  <span className="text-[10px] font-bold text-slate-400 opacity-0 group-hover:opacity-100 transition-opacity">
                    {item.val}
                  </span>
                  <div className="w-6 bg-slate-100 rounded-t-xl h-36 flex items-end overflow-hidden">
                    <div
                      style={{ height: `${item.height}%` }}
                      className="w-full bg-primary group-hover:bg-primary-dark transition-all rounded-t-xl"
                    />
                  </div>
                  <span className="text-[10px] font-bold text-slate-500">{item.day}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Low Stock Warning Table */}
        <div className="lg:col-span-4 bg-white border border-slate-200 rounded-2xl p-6 shadow-soft flex flex-col justify-between">
          <div>
            <div className="flex items-center space-x-2 text-rose-600 mb-4">
              <AlertTriangle className="w-5 h-5" />
              <h2 className="text-base font-bold text-slate-900">Low Stock Alerts</h2>
            </div>
            <p className="text-xs text-slate-500 mb-4">
              Items requiring stock re-order.
            </p>

            <div className="space-y-3">
              {(summary?.lowStockProducts?.length ? summary.lowStockProducts : [
                { id: '1', name: 'USB-C Fast Charger 65W', currentStock: 8, minStockAlert: 15, unit: 'Pcs' },
                { id: '2', name: 'Wireless Ergonomic Mouse', currentStock: 5, minStockAlert: 10, unit: 'Pcs' },
              ]).map((prod: any) => (
                <div
                  key={prod.id}
                  className="flex items-center justify-between p-3 rounded-xl bg-rose-50/50 border border-rose-100"
                >
                  <div>
                    <div className="text-xs font-bold text-slate-800">{prod.name}</div>
                    <div className="text-[10px] text-slate-400">Min Alert: {prod.minStockAlert} {prod.unit}</div>
                  </div>
                  <span className="text-xs font-extrabold text-rose-600 bg-white px-2 py-1 rounded-lg shadow-xs border border-rose-200">
                    {prod.currentStock} left
                  </span>
                </div>
              ))}
            </div>
          </div>

          <button
            onClick={onNavigateToInventory}
            className="w-full mt-6 py-2.5 rounded-xl border border-slate-200 text-xs font-bold text-slate-700 hover:bg-slate-50 transition-colors"
          >
            Manage All Products →
          </button>
        </div>
      </div>
    </div>
  );
};
